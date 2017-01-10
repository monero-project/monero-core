// Copyright (c) 2014-2015, The Monero Project
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../version.js" as Version


import "../components"
import moneroComponents.Clipboard 1.0

Rectangle {
    property var daemonAddress
    property bool viewOnly: false

    color: "#F0EEEE"

    Clipboard { id: clipboard }

    function initSettings() {
        //runs on every page load

        // Mnemonic seed setting
        memoTextInput.text = (viewOnly)? qsTr("View only wallets doesn't have a mnemonic seed") : qsTr("Click button to show seed") + translationManager.emptyString
        showSeedButton.enabled = !viewOnly

        // Daemon settings
        daemonAddress = persistentSettings.daemon_address.split(":");
        console.log("address: " + persistentSettings.daemon_address)
        // try connecting to daemon
    }


    ColumnLayout {
        id: mainLayout
        anchors.margins: 40
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: 10

        //! Manage wallet
        RowLayout {
            Label {
                id: manageWalletLabel
                Layout.fillWidth: true
                color: "#4A4949"
                text: qsTr("Manage wallet") + translationManager.emptyString
                fontSize: 16
                Layout.topMargin: 10
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#DEDEDE"
        }

        RowLayout {
            StandardButton {
                id: closeWalletButton
                width: 100
                text: qsTr("Close wallet") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                visible: true
                onClicked: {
                    console.log("closing wallet button clicked")
                    appWindow.showWizard();
                }
            }

            StandardButton {
                enabled: !viewOnly
                id: createViewOnlyWalletButton
                text: qsTr("Create view only wallet") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                visible: true
                onClicked: {
                    wizard.openCreateViewOnlyWalletPage();
                }
            }

        }

        //! show seed
        TextArea {
            enabled: !viewOnly
            id: memoTextInput
            textMargin: 6
            wrapMode: TextEdit.WordWrap
            readOnly: true
            selectByMouse: true
            font.pixelSize: 18
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignHCenter

            text: (viewOnly)? qsTr("View only wallets doesn't have a mnemonic seed") : qsTr("Click button to show seed") + translationManager.emptyString

            style: TextAreaStyle {
                  backgroundColor: "#FFFFFF"
              }

            Image {
                id : clipboardButton
                anchors.right: memoTextInput.right
                anchors.bottom: memoTextInput.bottom
                source: "qrc:///images/greyTriangle.png"

                Image {
                    anchors.centerIn: parent
                    source: "qrc:///images/copyToClipboard.png"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: clipboard.setText(memoTextInput.text)
                }
            }
        }


        RowLayout {
            enabled: !viewOnly
            Layout.fillWidth: true
            Text {
                id: wordsTipText
                font.family: "Arial"
                font.pointSize: 12
                color: "#4A4646"
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("This is very important to write down and keep secret. It is all you need to restore your wallet.")
                      + translationManager.emptyString
            }

            StandardButton {
                id: showSeedButton
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                text: qsTr("Show seed")
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    settingsPasswordDialog.open();
                }
            }
        }

        //! Manage daemon
        RowLayout {
            Label {
                id: manageDaemonLabel
                color: "#4A4949"
                text: qsTr("Manage daemon") + translationManager.emptyString
                fontSize: 16
                anchors.topMargin: 30
                Layout.topMargin: 30
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#DEDEDE"
        }

        RowLayout {
            StandardButton {
                visible: true
                enabled: !appWindow.daemonRunning
                id: startDaemonButton
                text: qsTr("Start daemon") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                onClicked: {
                    appWindow.startDaemon(daemonFlags.text)
                }
            }

            StandardButton {
                visible: true
                enabled: appWindow.daemonRunning
                id: stopDaemonButton
                text: qsTr("Stop daemon") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                onClicked: {
                    appWindow.stopDaemon()
                }
            }

            StandardButton {
                visible: true
                id: daemonConsolePopupButton
                text: qsTr("Show log") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                onClicked: {
                    daemonConsolePopup.open();
                }
            }
        }

        RowLayout {
            id: daemonFlagsRow
            Label {
                id: daemonFlagsLabel
                color: "#4A4949"
                text: qsTr("Daemon startup flags") + translationManager.emptyString
                fontSize: 16
            }
            LineEdit {
                id: daemonFlags
                Layout.preferredWidth:  200
                Layout.fillWidth: true
                text: appWindow.persistentSettings.daemonFlags;
                placeholderText: qsTr("(optional)") + translationManager.emptyString
            }
        }

        RowLayout {
            id: daemonAddrRow
            Layout.fillWidth: true
            spacing: 10

            Label {
                id: daemonAddrLabel

                Layout.fillWidth: true
                color: "#4A4949"
                text: qsTr("Daemon address") + translationManager.emptyString
                fontSize: 16
            }

            LineEdit {
                id: daemonAddr
                Layout.preferredWidth:  200
                Layout.fillWidth: true
                text: (daemonAddress !== undefined) ? daemonAddress[0] : ""
                placeholderText: qsTr("Hostname / IP")
            }


            LineEdit {
                id: daemonPort
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                text: (daemonAddress !== undefined) ? daemonAddress[1] : "18081"
                placeholderText: qsTr("Port")
            }


            StandardButton {
                id: daemonAddrSave
                Layout.fillWidth: false
                Layout.leftMargin: 30
                text: qsTr("Save") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                visible: true
                onClicked: {
                    console.log("saving daemon adress settings")
                    var newDaemon = daemonAddr.text + ":" + daemonPort.text
                    if(persistentSettings.daemon_address != newDaemon) {
                        persistentSettings.daemon_address = newDaemon
                        //reconnect wallet
                        appWindow.initialize();
                    }
                }
            }

        }

        RowLayout {
            Label {
                color: "#4A4949"
                text: qsTr("Layout settings") + translationManager.emptyString
                fontSize: 16
                anchors.topMargin: 30
                Layout.topMargin: 30
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#DEDEDE"
        }

        RowLayout {
            CheckBox {
                id: customDecorationsCheckBox
                checked: persistentSettings.customDecorations
                onClicked: appWindow.setCustomWindowDecorations(checked)
                text: qsTr("Custom decorations") + translationManager.emptyString
                checkedIcon: "../images/checkedVioletIcon.png"
                uncheckedIcon: "../images/uncheckedIcon.png"
            }
        }

        // Log level
        RowLayout {
            Label {
                id: logLevelLabel
                color: "#4A4949"
                text: qsTr("Log level") + translationManager.emptyString
                fontSize: 16
            }

            ComboBox {
                id: logLevel
                model: [0,1,2,3,4]
                currentIndex : appWindow.persistentSettings.logLevel;
                onCurrentIndexChanged: {
                    console.log("log level changed: ",currentIndex);
                    walletManager.setLogLevel(currentIndex);
                    appWindow.persistentSettings.logLevel = currentIndex;
                }
            }
        }

        // Version
        RowLayout {
            Label {
                color: "#4A4949"
                text: qsTr("Version") + translationManager.emptyString
                fontSize: 16
                anchors.topMargin: 30
                Layout.topMargin: 30
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#DEDEDE"
        }

        Label {
            id: guiVersion
            Layout.topMargin: 8
            color: "#4A4949"
            text: qsTr("GUI version: ") + Version.GUI_VERSION + translationManager.emptyString
            fontSize: 16
        }

        Label {
            id: guiMoneroVersion
            color: "#4A4949"
            text: qsTr("Embedded Monero version: ") + Version.GUI_MONERO_VERSION + translationManager.emptyString
            fontSize: 16
        }
    }

    // Daemon console
    StandardDialog {
        id: daemonConsolePopup
        height:500
        width:800
        cancelVisible: false
        title: qsTr("Daemon log")
        onAccepted: {
            close();
        }
    }

    PasswordDialog {
        id: settingsPasswordDialog

        onAccepted: {
            if(appWindow.password === settingsPasswordDialog.password){
                memoTextInput.text = currentWallet.seed
                showSeedButton.enabled = false
            } else {
                informationPopup.title  = qsTr("Error") + translationManager.emptyString;
                informationPopup.text = qsTr("Wrong password");
                informationPopup.open()
                informationPopup.onCloseCallback = function() {
                    settingsPasswordDialog.open()
                }
            }

            settingsPasswordDialog.password = ""
        }
        onRejected: {

        }

    }

    // fires on every page load
    function onPageCompleted() {
        console.log("Settings page loaded");
        initSettings();
        viewOnly = currentWallet.viewOnly;
    }

    // fires only once
    Component.onCompleted: {
        daemonManager.daemonConsoleUpdated.connect(onDaemonConsoleUpdated)
    }

    function onDaemonConsoleUpdated(message){
        // Update daemon console
        daemonConsolePopup.textArea.append(message)
    }




}




