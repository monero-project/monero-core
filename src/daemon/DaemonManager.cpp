// Copyright (c) 2014-2019, The Monero Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "DaemonManager.h"
#include <QElapsedTimer>
#include <QFile>
#include <QMutexLocker>
#include <QThread>
#include <QFileInfo>
#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QtConcurrent/QtConcurrent>
#include <QApplication>
#include <QProcess>
#include <QStorageInfo>
#include <QVariantMap>
#include <QVariant>
#include <QMap>

namespace {
    static const int DAEMON_START_TIMEOUT_SECONDS = 120;
}

DaemonManager * DaemonManager::m_instance = nullptr;
QStringList DaemonManager::m_clArgs;

DaemonManager *DaemonManager::instance(const QStringList *args/* = nullptr*/)
{
    if (!m_instance) {
        m_instance = new DaemonManager;
        // store command line arguments for later use
        if (args != nullptr)
        {
            m_clArgs = *args;
        }
    }

    return m_instance;
}

bool DaemonManager::start(const QString &flags, NetworkType::Type nettype, int rpcPort, const QString &dataDir, const QString &bootstrapNodeAddress, bool noSync /* = false*/, bool torsocks /*= false*/)
{
    if (!QFileInfo(m_monerod).isFile())
    {
        emit daemonStartFailure("\"" + QDir::toNativeSeparators(m_monerod) + "\" " + tr("executable is missing"));
        return false;
    }

    // prepare command line arguments and pass to monerod
    QStringList arguments;

    if(torsocks) {
        arguments << m_monerod << "--p2p-bind-ip" << "127.0.0.1";
    }

    // Start daemon with --detach flag on non-windows platforms
#ifndef Q_OS_WIN
    arguments << "--detach";
#endif

    if (nettype == NetworkType::TESTNET)
        arguments << "--testnet";
    else if (nettype == NetworkType::STAGENET)
        arguments << "--stagenet";

    foreach (const QString &str, m_clArgs) {
          qDebug() << QString(" [%1] ").arg(str);
          if (!str.isEmpty())
            arguments << str;
    }

    // Custom startup flags for daemon
    foreach (const QString &str, flags.split(" ")) {
          qDebug() << QString(" [%1] ").arg(str);
          if (!str.isEmpty())
            arguments << str;
    }

    // Custom data-dir
    if(!dataDir.isEmpty()) {
        arguments << "--data-dir" << dataDir;
    }

    // Bootstrap node address
    if(!bootstrapNodeAddress.isEmpty()) {
        arguments << "--bootstrap-daemon-address" << bootstrapNodeAddress;
    }

    if (noSync) {
        arguments << "--no-sync";
    }

    if (rpcPort) {
        arguments << "--rpc-bind-port" << QString::number(rpcPort);
    }

    arguments << "--check-updates" << "disabled";

    // --max-concurrency based on threads available. max: 6
    int32_t concurrency = qBound(1, QThread::idealThreadCount() / 2, 6);

    if(!flags.contains("--max-concurrency", Qt::CaseSensitive)){
        arguments << "--max-concurrency" << QString::number(concurrency);
    }

    qDebug() << "starting monerod " + m_monerod;
    qDebug() << "With command line arguments " << arguments;

    QMutexLocker locker(&m_daemonMutex);

    m_daemon.reset(new QProcess());

    // Connect output slots
    connect(m_daemon.get(), SIGNAL(readyReadStandardOutput()), this, SLOT(printOutput()));
    connect(m_daemon.get(), SIGNAL(readyReadStandardError()), this, SLOT(printError()));

    // Start monerod
    bool started = m_daemon->startDetached(torsocks ? "torsocks" : m_monerod, arguments);

    // add state changed listener
    connect(m_daemon.get(), SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(stateChanged(QProcess::ProcessState)));

    if (!started) {
        qDebug() << "Daemon start error: " + m_daemon->errorString();
        emit daemonStartFailure(m_daemon->errorString());
        return false;
    }

    // Start start watcher
    m_scheduler.run([this, nettype, rpcPort, noSync] {
        if (startWatcher(nettype, rpcPort)) {
            emit daemonStarted();
            m_noSync = noSync;
        } else {
            emit daemonStartFailure(tr("Timed out, local node is not responding after %1 seconds").arg(DAEMON_START_TIMEOUT_SECONDS));
        }
    });

    return true;
}

void DaemonManager::stopAsync(NetworkType::Type nettype, int rpcPort, const QJSValue& callback)
{
    const auto feature = m_scheduler.run([this, nettype, rpcPort] {
        QString message;
        sendCommand({"exit"}, nettype, rpcPort, message);

        return QJSValueList({stopWatcher(nettype, rpcPort)});
    }, callback);

    if (!feature.first)
    {
        QJSValue(callback).call(QJSValueList({false}));
    }
}

bool DaemonManager::startWatcher(NetworkType::Type nettype, int rpcPort) const
{
    // Check if daemon is started every 2 seconds
    QElapsedTimer timer;
    timer.start();
    while(true && !m_app_exit && timer.elapsed() / 1000 < DAEMON_START_TIMEOUT_SECONDS  ) {
        QThread::sleep(2);
        if(!running(nettype, rpcPort)) {
            qDebug() << "daemon not running. checking again in 2 seconds.";
        } else {
            qDebug() << "daemon is started. Waiting 5 seconds to let daemon catch up";
            QThread::sleep(5);
            return true;
        }
    }
    return false;
}

bool DaemonManager::stopWatcher(NetworkType::Type nettype, int rpcPort) const
{
    // Check if daemon is running every 2 seconds. Kill if still running after 10 seconds
    int counter = 0;
    while(true && !m_app_exit) {
        QThread::sleep(2);
        counter++;
        if(running(nettype, rpcPort)) {
            qDebug() << "Daemon still running.  " << counter;
            if(counter >= 5) {
                qDebug() << "Killing it! ";
#ifdef Q_OS_WIN
                QProcess::execute("taskkill",  {"/F", "/IM", "monerod.exe"});
#else
                QProcess::execute("pkill", {"--signal", "SIGKILL", "monerod"});
#endif
            }

        } else
            return true;
    }
    return false;
}


void DaemonManager::stateChanged(QProcess::ProcessState state)
{
    qDebug() << "STATE CHANGED: " << state;
    if (state == QProcess::NotRunning) {
        emit daemonStopped();
    }
}

void DaemonManager::printOutput()
{
    QByteArray byteArray = [this]() {
        QMutexLocker locker(&m_daemonMutex);
        return m_daemon->readAllStandardOutput();
    }();
    QStringList strLines = QString(byteArray).split("\n");

    foreach (QString line, strLines) {
        emit daemonConsoleUpdated(line);
        qDebug() << "Daemon: " + line;
    }
}

void DaemonManager::printError()
{
    QByteArray byteArray = [this]() {
        QMutexLocker locker(&m_daemonMutex);
        return m_daemon->readAllStandardError();
    }();
    QStringList strLines = QString(byteArray).split("\n");

    foreach (QString line, strLines) {
        emit daemonConsoleUpdated(line);
        qDebug() << "Daemon ERROR: " + line;
    }
}

bool DaemonManager::running(NetworkType::Type nettype, int rpcPort) const
{ 
    QString status;
    sendCommand({"sync_info"}, nettype, rpcPort, status);
    qDebug() << status;
    return status.contains("Height:");
}

bool DaemonManager::noSync() const noexcept
{
    return m_noSync;
}

void DaemonManager::runningAsync(NetworkType::Type nettype, int rpcPort, const QJSValue& callback) const
{ 
    m_scheduler.run([this, nettype, rpcPort] {
        return QJSValueList({running(nettype, rpcPort)});
    }, callback);
}

bool DaemonManager::sendCommand(const QStringList &cmd, NetworkType::Type nettype, int rpcPort, QString &message) const
{
    QProcess p;
    QStringList external_cmd(cmd);

    // Add network type flag if needed
    if (nettype == NetworkType::TESTNET)
        external_cmd << "--testnet";
    else if (nettype == NetworkType::STAGENET)
        external_cmd << "--stagenet";

    if (rpcPort){
        external_cmd << "--rpc-bind-port" << QString::number(rpcPort);
    }

    qDebug() << "sending external cmd: " << external_cmd;

    p.start(m_monerod, external_cmd);

    bool started = p.waitForFinished(-1);
    message = p.readAllStandardOutput();
    emit daemonConsoleUpdated(message);
    return started;
}

void DaemonManager::sendCommandAsync(const QStringList &cmd, NetworkType::Type nettype, int rpcPort, const QJSValue& callback) const
{
    m_scheduler.run([this, cmd, nettype, rpcPort] {
        QString message;
        return QJSValueList({sendCommand(cmd, nettype, rpcPort, message)});
    }, callback);
}

void DaemonManager::exit()
{
    qDebug("DaemonManager: exit()");
    m_app_exit = true;
}

QVariantMap DaemonManager::validateDataDir(const QString &dataDir) const
{
    QVariantMap result;
    bool valid = true;
    bool readOnly = false;
    int  storageAvailable = 0;
    bool lmdbExists = true;

    QStorageInfo storage(dataDir);
    if (storage.isValid() && storage.isReady()) {
        if (storage.isReadOnly()) {
            readOnly = true;
            valid = false;
        }

        // Make sure there is 75GB storage available
        storageAvailable = storage.bytesAvailable()/1000/1000/1000;
        if (storageAvailable < 75) {
            valid = false;
        }
    } else {
        valid = false;
    }


    if (!QDir(dataDir+"/lmdb").exists()) {
        lmdbExists = false;
        valid = false;
    }

    result.insert("valid", valid);
    result.insert("lmdbExists", lmdbExists);
    result.insert("readOnly", readOnly);
    result.insert("storageAvailable", storageAvailable);

    return result;
}

DaemonManager::DaemonManager(QObject *parent)
    : QObject(parent)
    , m_scheduler(this)
{

    // Platform depetent path to monerod
#ifdef Q_OS_WIN
    m_monerod = QApplication::applicationDirPath() + "/monerod.exe";
#elif defined(Q_OS_UNIX)
    m_monerod = QApplication::applicationDirPath() + "/monerod";
#endif

    if (m_monerod.length() == 0) {
        qCritical() << "no daemon binary defined for current platform";
    }
}

DaemonManager::~DaemonManager()
{
    m_scheduler.shutdownWaitForFinished();
}
