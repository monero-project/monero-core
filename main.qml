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

import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

import moneroComponents.Wallet 1.0
import moneroComponents.PendingTransaction 1.0


import "components"
import "wizard"

ApplicationWindow {
    id: appWindow


    property var currentItem
    property bool whatIsEnable: false
    property bool ctrlPressed: false
    property bool rightPanelExpanded: false
    property bool osx: false
    property alias persistentSettings : persistentSettings
    property var currentWallet;
    property var transaction;
    property var transactionDescription;
    property alias password : passwordDialog.password
    property int splashCounter: 0
    property bool isNewWallet: false
    property int restoreHeight:0
    property bool daemonSynced: false
    property int maxWindowHeight: (Screen.height < 900)? 720 : 800;
    property bool daemonRunning: false
    property alias toolTip: toolTip
    property string walletName
    property bool viewOnly: false
    property bool foundNewBlock: false
    property int timeToUnlock: 0

    // true if wallet ever synchronized
    property bool walletInitialized : false

    function altKeyReleased() { ctrlPressed = false; }

    function showPageRequest(page) {
        middlePanel.state = page
        leftPanel.selectItem(page)
    }

    function sequencePressed(obj, seq) {
        if(seq === undefined)
            return
        if(seq === "Ctrl") {
            ctrlPressed = true
            return
        }

        if(seq === "Ctrl+D") middlePanel.state = "Dashboard"
        else if(seq === "Ctrl+S") middlePanel.state = "Transfer"
        else if(seq === "Ctrl+R") middlePanel.state = "Receive"
        else if(seq === "Ctrl+K") middlePanel.state = "TxKey"
        else if(seq === "Ctrl+H") middlePanel.state = "History"
        else if(seq === "Ctrl+B") middlePanel.state = "AddressBook"
        else if(seq === "Ctrl+M") middlePanel.state = "Mining"
        else if(seq === "Ctrl+I") middlePanel.state = "Sign"
        else if(seq === "Ctrl+E") middlePanel.state = "Settings"
        else if(seq === "Ctrl+Tab" || seq === "Alt+Tab") {
            /*
            if(middlePanel.state === "Dashboard") middlePanel.state = "Transfer"
            else if(middlePanel.state === "Transfer") middlePanel.state = "Receive"
            else if(middlePanel.state === "Receive") middlePanel.state = "TxKey"
            else if(middlePanel.state === "TxKey") middlePanel.state = "History"
            else if(middlePanel.state === "History") middlePanel.state = "AddressBook"
            else if(middlePanel.state === "AddressBook") middlePanel.state = "Mining"
            else if(middlePanel.state === "Mining") middlePanel.state = "Sign"
            else if(middlePanel.state === "Sign") middlePanel.state = "Settings"
            else if(middlePanel.state === "Settings") middlePanel.state = "Dashboard"
            */
            if(middlePanel.state === "Settings") middlePanel.state = "Transfer"
            else if(middlePanel.state === "Transfer") middlePanel.state = "Receive"
            else if(middlePanel.state === "Receive") middlePanel.state = "TxKey"
            else if(middlePanel.state === "TxKey") middlePanel.state = "History"
            else if(middlePanel.state === "History") middlePanel.state = "AddressBook"
            else if(middlePanel.state === "AddressBook") middlePanel.state = "Sign"
            else if(middlePanel.state === "Sign") middlePanel.state = "Settings"
        } else if(seq === "Ctrl+Shift+Backtab" || seq === "Alt+Shift+Backtab") {
            /*
            if(middlePanel.state === "Dashboard") middlePanel.state = "Settings"
            if(middlePanel.state === "Settings") middlePanel.state = "Sign"
            else if(middlePanel.state === "Sign") middlePanel.state = "Mining"
            else if(middlePanel.state === "Mining") middlePanel.state = "AddressBook"
            else if(middlePanel.state === "AddressBook") middlePanel.state = "History"
            else if(middlePanel.state === "History") middlePanel.state = "TxKey"
            else if(middlePanel.state === "TxKey") middlePanel.state = "Receive"
            else if(middlePanel.state === "Receive") middlePanel.state = "Transfer"
            else if(middlePanel.state === "Transfer") middlePanel.state = "Dashboard"
            */
            if(middlePanel.state === "Settings") middlePanel.state = "Sign"
            else if(middlePanel.state === "Sign") middlePanel.state = "AddressBook"
            else if(middlePanel.state === "AddressBook") middlePanel.state = "History"
            else if(middlePanel.state === "History") middlePanel.state = "TxKey"
            else if(middlePanel.state === "TxKey") middlePanel.state = "Receive"
            else if(middlePanel.state === "Receive") middlePanel.state = "Transfer"
            else if(middlePanel.state === "Transfer") middlePanel.state = "Settings"
        }

        leftPanel.selectItem(middlePanel.state)
    }

    function sequenceReleased(obj, seq) {
        if(seq === "Ctrl")
            ctrlPressed = false
    }

    function mousePressed(obj, mouseX, mouseY) {}
    function mouseReleased(obj, mouseX, mouseY) {}

    function openWalletFromFile(){
        persistentSettings.restore_height = 0
        restoreHeight = 0;
        persistentSettings.is_recovering = false
        appWindow.password = ""
        fileDialog.open();
    }

    function initialize() {
        console.log("initializing..")
        walletInitialized = false;

        // Use stored log level
        walletManager.setLogLevel(persistentSettings.logLevel)

        // setup language
        var locale = persistentSettings.locale
        if (locale !== "") {
            translationManager.setLanguage(locale.split("_")[0]);
        }

        // If currentWallet exists, we're just switching daemon - close/reopen wallet
        if (typeof currentWallet !== "undefined" && currentWallet !== null) {
            console.log("Daemon change - closing " + currentWallet)
            closeWallet();
            currentWallet = undefined
        } else {

            // set page to transfer if not changing daemon
            middlePanel.state = "Transfer";
            leftPanel.selectItem(middlePanel.state)

        }

        walletManager.setDaemonAddress(persistentSettings.daemon_address)

        // wallet already opened with wizard, we just need to initialize it
        if (typeof wizard.settings['wallet'] !== 'undefined') {
            console.log("using wizard wallet")
            //Set restoreHeight
            if(persistentSettings.restore_height > 0){
                // We store restore height in own variable for performance reasons.
                restoreHeight = persistentSettings.restore_height
            }

            connectWallet(wizard.settings['wallet'])

            isNewWallet = true
            // We don't need the wizard wallet any more - delete to avoid conflict with daemon adress change
            delete wizard.settings['wallet']
        }  else {
            var wallet_path = walletPath();
            // console.log("opening wallet at: ", wallet_path, "with password: ", appWindow.password);
            console.log("opening wallet at: ", wallet_path, ", testnet: ", persistentSettings.testnet);
            walletManager.openWalletAsync(wallet_path, appWindow.password,
                                              persistentSettings.testnet);
        }

    }
    function closeWallet() {

        // Disconnect all listeners
        if (typeof currentWallet !== "undefined" && currentWallet !== null) {
            currentWallet.refreshed.disconnect(onWalletRefresh)
            currentWallet.updated.disconnect(onWalletUpdate)
            currentWallet.newBlock.disconnect(onWalletNewBlock)
            currentWallet.moneySpent.disconnect(onWalletMoneySent)
            currentWallet.moneyReceived.disconnect(onWalletMoneyReceived)
            currentWallet.unconfirmedMoneyReceived.disconnect(onWalletUnconfirmedMoneyReceived)
            currentWallet.transactionCreated.disconnect(onTransactionCreated)
            currentWallet.connectionStatusChanged.disconnect(onWalletConnectionStatusChanged)
            middlePanel.paymentClicked.disconnect(handlePayment);
            middlePanel.sweepUnmixableClicked.disconnect(handleSweepUnmixable);
            middlePanel.checkPaymentClicked.disconnect(handleCheckPayment);
        }
        currentWallet = undefined;
        walletManager.closeWalletAsync();
    }

    function connectWallet(wallet) {
        showProcessingSplash("Please wait...")
        currentWallet = wallet
        updateSyncing(false)

        // connect handlers
        currentWallet.refreshed.connect(onWalletRefresh)
        currentWallet.updated.connect(onWalletUpdate)
        currentWallet.newBlock.connect(onWalletNewBlock)
        currentWallet.moneySpent.connect(onWalletMoneySent)
        currentWallet.moneyReceived.connect(onWalletMoneyReceived)
        currentWallet.unconfirmedMoneyReceived.connect(onWalletUnconfirmedMoneyReceived)
        currentWallet.transactionCreated.connect(onTransactionCreated)
        currentWallet.connectionStatusChanged.connect(onWalletConnectionStatusChanged)
        middlePanel.paymentClicked.connect(handlePayment);
        middlePanel.sweepUnmixableClicked.connect(handleSweepUnmixable);
        middlePanel.checkPaymentClicked.connect(handleCheckPayment);

        console.log("initializing with daemon address: ", persistentSettings.daemon_address)
        console.log("Recovering from seed: ", persistentSettings.is_recovering)
        console.log("restore Height", persistentSettings.restore_height)
        currentWallet.initAsync(persistentSettings.daemon_address, 0, persistentSettings.is_recovering, persistentSettings.restore_height);
    }

    function walletPath() {
        var wallet_path = persistentSettings.wallet_path
        return wallet_path;
    }

    function onWalletConnectionStatusChanged(){
        console.log("Wallet connection status changed")
        middlePanel.updateStatus();
    }

    function onWalletOpened(wallet) {
        console.log(">>> wallet opened: " + wallet)
        if (wallet.status !== Wallet.Status_Ok) {
            if (appWindow.password === '') {
                console.error("Error opening wallet with empty password: ", wallet.errorString);
                console.log("closing wallet async : " + wallet.address)
                closeWallet();
                // try to open wallet with password;
                passwordDialog.open(wallet.path);
            } else {
                // opening with password but password doesn't match
                console.error("Error opening wallet with password: ", wallet.errorString);

                informationPopup.title  = qsTr("Error") + translationManager.emptyString;
                informationPopup.text = qsTr("Couldn't open wallet: ") + wallet.errorString;
                informationPopup.icon = StandardIcon.Critical
                console.log("closing wallet async : " + wallet.address)
                closeWallet();
                informationPopup.open()
                informationPopup.onCloseCallback = function() {
                    passwordDialog.open(wallet.path)
                }
            }
            return;
        }

        // wallet opened successfully, subscribing for wallet updates
        connectWallet(wallet)

    }


    function onWalletClosed(walletAddress) {
        console.log(">>> wallet closed: " + walletAddress)
    }

    function onWalletUpdate() {
        console.log(">>> wallet updated")
        middlePanel.unlockedBalanceText = leftPanel.unlockedBalanceText =  walletManager.displayAmount(currentWallet.unlockedBalance);
        middlePanel.balanceText = leftPanel.balanceText = walletManager.displayAmount(currentWallet.balance);
        console.log("time to unlock: ", currentWallet.history.minutesToUnlock);
        // Update history if new block found since last update and balance is locked.
        if(foundNewBlock && currentWallet.history.locked) {
            foundNewBlock = false;
            console.log("New block found - updating history")
            currentWallet.history.refresh()
            timeToUnlock = currentWallet.history.minutesToUnlock
            leftPanel.minutesToUnlockTxt = (timeToUnlock > 0)? qsTr("Unlocked balance (~%1 min)").arg(timeToUnlock) : qsTr("Unlocked balance");
        }
    }

    function onWalletRefresh() {
        console.log(">>> wallet refreshed")
        if (splash.visible) {
            hideProcessingSplash()
        }

        // Daemon connected
        leftPanel.networkStatus.connected = currentWallet.connected

        // Check daemon status
        var dCurrentBlock = currentWallet.daemonBlockChainHeight();
        var dTargetBlock = currentWallet.daemonBlockChainTargetHeight();

        // Daemon fully synced
        // TODO: implement onDaemonSynced or similar in wallet API and don't start refresh thread before daemon is synced
        daemonSynced = (currentWallet.connected != Wallet.ConnectionStatus_Disconnected && dCurrentBlock >= dTargetBlock)
        leftPanel.progressBar.updateProgress(dCurrentBlock,dTargetBlock);
        updateSyncing((currentWallet.connected !== Wallet.ConnectionStatus_Disconnected) && (dCurrentBlock < dTargetBlock))
        middlePanel.updateStatus();

        // If wallet isnt connected and no daemon is running - Ask
        if(currentWallet.connected === Wallet.ConnectionStatus_Disconnected && !daemonManager.running() && !walletInitialized){
            daemonManagerDialog.open();
        }

        // Refresh is succesfull if blockchain height > 1
        if (currentWallet.blockChainHeight() > 1){

            // Save new wallet after first refresh
            // Wallet is nomrmally saved to disk on app exit. This prevents rescan from block 0 after app crash
            if(isNewWallet){
                console.log("Saving wallet after first refresh");
                currentWallet.store()
                isNewWallet = false
            }

            // recovering from seed is finished after first refresh
            if(persistentSettings.is_recovering) {
                persistentSettings.is_recovering = false
            }
        }

        // initialize transaction history once wallet is initializef first time;
        if (!walletInitialized) {
            currentWallet.history.refresh()
            walletInitialized = true
        } 
        onWalletUpdate();
    }

    function startDaemon(flags){
        appWindow.showProcessingSplash(qsTr("Waiting for daemon to start..."))
        daemonManager.start(flags);
        persistentSettings.daemonFlags = flags
    }

    function stopDaemon(){
        appWindow.showProcessingSplash(qsTr("Waiting for daemon to stop..."))
        daemonManager.stop();
    }

    function onDaemonStarted(){
        console.log("daemon started");
        daemonRunning = true;
    }
    function onDaemonStopped(){
        console.log("daemon stopped");
        hideProcessingSplash();
        daemonRunning = false;
    }

    function onWalletNewBlock(blockHeight) {
            // Update progress bar
            var currHeight = blockHeight
            //fast refresh until restoreHeight is reached
            var increment = ((restoreHeight == 0) || currHeight < restoreHeight)? 1000 : 10

            if(currHeight > splashCounter + increment){
              splashCounter = currHeight
              leftPanel.progressBar.updateProgress(currHeight,currentWallet.daemonBlockChainTargetHeight());
            }
            foundNewBlock = true;
    }

    function onWalletMoneyReceived(txId, amount) {
        // refresh transaction history here
        currentWallet.refresh()
        currentWallet.history.refresh() // this will refresh model
    }

    function onWalletUnconfirmedMoneyReceived(txId, amount) {
        // refresh history
        console.log("unconfirmed money found")
        currentWallet.history.refresh()
    }

    function onWalletMoneySent(txId, amount) {
        // refresh transaction history here
        currentWallet.refresh()
        currentWallet.history.refresh() // this will refresh model
    }

    function walletsFound() {
        if (persistentSettings.wallet_path.length > 0) {
            return walletManager.walletExists(persistentSettings.wallet_path);
        }
        return false;
    }

    function onTransactionCreated(pendingTransaction,address,paymentId,mixinCount){
        console.log("Transaction created");
        hideProcessingSplash();
        transaction = pendingTransaction;
        // validate address;
        if (transaction.status !== PendingTransaction.Status_Ok) {
            console.error("Can't create transaction: ", transaction.errorString);
            informationPopup.title = qsTr("Error") + translationManager.emptyString;
            if (currentWallet.connected == Wallet.ConnectionStatus_WrongVersion)
                informationPopup.text  = qsTr("Can't create transaction: Wrong daemon version: ") + transaction.errorString
            else
                informationPopup.text  = qsTr("Can't create transaction: ") + transaction.errorString
            informationPopup.icon  = StandardIcon.Critical
            informationPopup.onCloseCallback = null
            informationPopup.open();
            // deleting transaction object, we don't want memleaks
            currentWallet.disposeTransaction(transaction);

        } else if (transaction.txCount == 0) {
            informationPopup.title = qsTr("No unmixable outputs to sweep") + translationManager.emptyString
            informationPopup.text  = qsTr("No unmixable outputs to sweep") + translationManager.emptyString
            informationPopup.icon = StandardIcon.Information
            informationPopup.onCloseCallback = null
            informationPopup.open()
            // deleting transaction object, we don't want memleaks
            currentWallet.disposeTransaction(transaction);
        } else {
            console.log("Transaction created, amount: " + walletManager.displayAmount(transaction.amount)
                    + ", fee: " + walletManager.displayAmount(transaction.fee));

            // here we show confirmation popup;

            transactionConfirmationPopup.title = qsTr("Confirmation") + translationManager.emptyString
            transactionConfirmationPopup.text  = qsTr("Please confirm transaction:\n")
                        + (address === "" ? "" : (qsTr("\nAddress: ") + address))
                        + (paymentId === "" ? "" : (qsTr("\nPayment ID: ") + paymentId))
                        + qsTr("\n\nAmount: ") + walletManager.displayAmount(transaction.amount)
                        + qsTr("\nFee: ") + walletManager.displayAmount(transaction.fee)
                        + qsTr("\n\nMixin: ") + mixinCount
                        + qsTr("\n\Number of transactions: ") + transaction.txCount
                        + (transactionDescription === "" ? "" : (qsTr("\n\nDescription: ") + transactionDescription))
                        + translationManager.emptyString
            transactionConfirmationPopup.icon = StandardIcon.Question
            transactionConfirmationPopup.open()
        }
    }


    // called on "transfer"
    function handlePayment(address, paymentId, amount, mixinCount, priority, description) {
        console.log("Creating transaction: ")
        console.log("\taddress: ", address,
                    ", payment_id: ", paymentId,
                    ", amount: ", amount,
                    ", mixins: ", mixinCount,
                    ", priority: ", priority,
                    ", description: ", description);

        showProcessingSplash("Creating transaction");

        transactionDescription = description;

        // validate amount;
        if (amount !== "(all)") {
            var amountxmr = walletManager.amountFromString(amount);
            console.log("integer amount: ", amountxmr);
            console.log("integer unlocked",currentWallet.unlockedBalance)
            if (amountxmr <= 0) {
                informationPopup.title = qsTr("Error") + translationManager.emptyString;
                informationPopup.text  = qsTr("Amount is wrong: expected number from %1 to %2")
                        .arg(walletManager.displayAmount(0))
                        .arg(walletManager.maximumAllowedAmountAsSting())
                        + translationManager.emptyString

                informationPopup.icon  = StandardIcon.Critical
                informationPopup.onCloseCallback = null
                informationPopup.open()
                return;
            } else if (amountxmr > currentWallet.unlockedBalance) {
                informationPopup.title = qsTr("Error") + translationManager.emptyString;
                informationPopup.text  = qsTr("insufficient funds. Unlocked balance: %1")
                        .arg(walletManager.displayAmount(currentWallet.unlockedBalance))
                        + translationManager.emptyString

                informationPopup.icon  = StandardIcon.Critical
                informationPopup.onCloseCallback = null
                informationPopup.open()
                return;
            }
        }

        if (amount === "(all)")
            currentWallet.createTransactionAllAsync(address, paymentId, mixinCount, priority);
        else
            currentWallet.createTransactionAsync(address, paymentId, amountxmr, mixinCount, priority);
    }

    function handleSweepUnmixable() {
        console.log("Creating transaction: ")

        transaction = currentWallet.createSweepUnmixableTransaction();
        if (transaction.status !== PendingTransaction.Status_Ok) {
            console.error("Can't create transaction: ", transaction.errorString);
            informationPopup.title = qsTr("Error") + translationManager.emptyString;
            informationPopup.text  = qsTr("Can't create transaction: ") + transaction.errorString
            informationPopup.icon  = StandardIcon.Critical
            informationPopup.onCloseCallback = null
            informationPopup.open();
            // deleting transaction object, we don't want memleaks
            currentWallet.disposeTransaction(transaction);

        } else if (transaction.txCount == 0) {
            informationPopup.title = qsTr("No unmixable outputs to sweep") + translationManager.emptyString
            informationPopup.text  = qsTr("No unmixable outputs to sweep") + translationManager.emptyString
            informationPopup.icon = StandardIcon.Information
            informationPopup.onCloseCallback = null
            informationPopup.open()
            // deleting transaction object, we don't want memleaks
            currentWallet.disposeTransaction(transaction);
        } else {
            console.log("Transaction created, amount: " + walletManager.displayAmount(transaction.amount)
                    + ", fee: " + walletManager.displayAmount(transaction.fee));

            // here we show confirmation popup;

            transactionConfirmationPopup.title = qsTr("Confirmation") + translationManager.emptyString
            transactionConfirmationPopup.text  = qsTr("Please confirm transaction:\n")
                        + qsTr("\n\nAmount: ") + walletManager.displayAmount(transaction.amount)
                        + qsTr("\nFee: ") + walletManager.displayAmount(transaction.fee)
                        + translationManager.emptyString
            transactionConfirmationPopup.icon = StandardIcon.Question
            transactionConfirmationPopup.open()
            // committing transaction
        }
    }

    // called after user confirms transaction
    function handleTransactionConfirmed() {
        // grab transaction.txid before commit, since it clears it.
        // we actually need to copy it, because QML will incredibly
        // call the function multiple times when the variable is used
        // after commit, where it returns another result...
        // Of course, this loop is also calling the function multiple
        // times, but at least with the same result.
        var txid = [], txid_org = transaction.txid, txid_text = ""
        for (var i = 0; i < txid_org.length; ++i)
          txid[i] = txid_org[i]

        if (!transaction.commit()) {
            console.log("Error committing transaction: " + transaction.errorString);
            informationPopup.title = qsTr("Error") + translationManager.emptyString
            informationPopup.text  = qsTr("Couldn't send the money: ") + transaction.errorString
            informationPopup.icon  = StandardIcon.Critical
        } else {
            informationPopup.title = qsTr("Information") + translationManager.emptyString
            for (var i = 0; i < txid.length; ++i) {
                if (txid_text.length > 0)
                    txid_text += ", "
                txid_text += txid[i]
            }
            informationPopup.text  = qsTr("Money sent successfully: %1 transaction(s) ").arg(txid.length) + txid_text + translationManager.emptyString
            informationPopup.icon  = StandardIcon.Information
            if (transactionDescription.length > 0) {
                for (var i = 0; i < txid.length; ++i)
                  currentWallet.setUserNote(txid[i], transactionDescription);
            }
        }
        informationPopup.onCloseCallback = null
        informationPopup.open()
        currentWallet.refresh()
        currentWallet.disposeTransaction(transaction)
        currentWallet.store();
    }

    // called on "checkPayment"
    function handleCheckPayment(address, txid, txkey) {
        console.log("Checking payment: ")
        console.log("\taddress: ", address,
                    ", txid: ", txid,
                    ", txkey: ", txkey);

        var result = walletManager.checkPayment(address, txid, txkey, persistentSettings.daemon_address);
        var results = result.split("|");
        if (results.length < 4) {
            informationPopup.title  = qsTr("Error") + translationManager.emptyString;
            informationPopup.text = "internal error";
            informationPopup.icon = StandardIcon.Critical
            informationPopup.open()
            return
        }
        var success = results[0] == "true";
        var received = results[1]
        var height = results[2]
        var error = results[3]
        if (success) {
            informationPopup.title  = qsTr("Payment check") + translationManager.emptyString;
            informationPopup.icon = StandardIcon.Information
            if (received > 0) {
                received = received / 1e12
                if (height == 0) {
                    informationPopup.text = qsTr("This address received %1 monero, but the transaction is not yet mined").arg(received);
                }
                else {
                    var dCurrentBlock = currentWallet.daemonBlockChainHeight();
                    var confirmations = dCurrentBlock - height
                    informationPopup.text = qsTr("This address received %1 monero, with %2 confirmations").arg(received).arg(confirmations);
                }
            }
            else {
                informationPopup.text = qsTr("This address received nothing");
            }
        }
        else {
            informationPopup.title  = qsTr("Error") + translationManager.emptyString;
            informationPopup.text = error;
            informationPopup.icon = StandardIcon.Critical
        }
        informationPopup.open()
    }

    function updateSyncing(syncing) {
        var text = (syncing ? qsTr("Balance (syncing)") : qsTr("Balance")) + translationManager.emptyString
        leftPanel.balanceLabelText = text
        middlePanel.balanceLabelText = text
    }

    // blocks UI if wallet can't be opened or no connection to the daemon
    function enableUI(enable) {
        middlePanel.enabled = enable;
        leftPanel.enabled = enable;
        rightPanel.enabled = enable;
    }

    function showProcessingSplash(message) {
        console.log("Displaying processing splash")
        if (typeof message != 'undefined') {
            splash.messageText = message
            splash.heightProgressText = ""
        }
        splash.show()
    }

    function hideProcessingSplash() {
        console.log("Hiding processing splash")
        splash.close()
    }

    // close wallet and show wizard
    function showWizard(){
        walletInitialized = false;
        splashCounter = 0;
        closeWallet();
        currentWallet = undefined;
        wizard.restart();
        rootItem.state = "wizard"
    }


    objectName: "appWindow"
    visible: true
    width: rightPanelExpanded ? 1269 : 1269 - 300
    height: maxWindowHeight;
    color: "#FFFFFF"
    flags: persistentSettings.customDecorations ? (Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.Window | Qt.WindowMinimizeButtonHint) : (Qt.WindowSystemMenuHint | Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint | Qt.WindowTitleHint | Qt.WindowMaximizeButtonHint)
    onWidthChanged: x -= 0

    function setCustomWindowDecorations(custom) {
      var x = appWindow.x
      var y = appWindow.y
      if (x < 0)
        x = 0
      if (y < 0)
        y = 0
      persistentSettings.customDecorations = custom
      if (custom)
        appWindow.flags = Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.Window | Qt.WindowMinimizeButtonHint
      else
        appWindow.flags = Qt.WindowSystemMenuHint | Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint | Qt.WindowTitleHint | Qt.WindowMaximizeButtonHint
      appWindow.hide()
      appWindow.x = x
      appWindow.y = y
      appWindow.show()
    }

    Component.onCompleted: {
        x = (Screen.width - width) / 2
        y = (Screen.height - maxWindowHeight) / 2
        //
        walletManager.walletOpened.connect(onWalletOpened);
        walletManager.walletClosed.connect(onWalletClosed);

        daemonManager.daemonStarted.connect(onDaemonStarted);
        daemonManager.daemonStopped.connect(onDaemonStopped);

        if(!walletsFound()) {
            rootItem.state = "wizard"
        } else {
            rootItem.state = "normal"
                initialize(persistentSettings);
        }

    }

    onRightPanelExpandedChanged: {
        if (rightPanelExpanded) {
            rightPanel.updateTweets()
        }
    }


    Settings {
        id: persistentSettings
        property string language
        property string locale
        property string account_name
        property string wallet_path
        property bool   auto_donations_enabled : false
        property int    auto_donations_amount : 50
        property bool   allow_background_mining : false
        property bool   testnet: false
        property string daemon_address: "localhost:18081"
        property string payment_id
        property int    restore_height : 0
        property bool   is_recovering : false
        property bool   customDecorations : true
        property string daemonFlags
        property int logLevel: 0
    }

    // Information dialog
    StandardDialog {
        // dynamically change onclose handler
        property var onCloseCallback
        id: informationPopup
        cancelVisible: false
        onAccepted:  {
            if (onCloseCallback) {
                onCloseCallback()
            }
        }
    }

    // Confrirmation aka question dialog
    StandardDialog {
        id: transactionConfirmationPopup
        onAccepted: {
            close();
            handleTransactionConfirmed()
        }
    }

    //Open Wallet from file
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: "file://" +moneroAccountsDir
        nameFilters: [ "Wallet files (*.keys)"]

        onAccepted: {
            persistentSettings.wallet_path = walletManager.urlToLocalPath(fileDialog.fileUrl)
            initialize();
        }
        onRejected: {
            console.log("Canceled")
            rootItem.state = "wizard";
        }

    }

    PasswordDialog {
        id: passwordDialog

        onAccepted: {
            appWindow.initialize();
        }
        onRejected: {
            //appWindow.enableUI(false)
            rootItem.state = "wizard"
        }

    }

    DaemonManagerDialog {
        id: daemonManagerDialog

    }

    ProcessingSplash {
        id: splash
        width: appWindow.width / 1.5
        height: appWindow.height / 2
        x: (appWindow.width - width) / 2 + appWindow.x
        y: (appWindow.height - height) / 2 + appWindow.y
        messageText: qsTr("Please wait...")
    }

    QRCodeScanner {
        id: cameraUi
        visible : false
    }

    Item {
        id: rootItem
        anchors.fill: parent
        clip: true

        state: "wizard"
        states: [
            State {
                name: "wizard"
                PropertyChanges { target: leftPanel; visible: false }
                PropertyChanges { target: rightPanel; visible: false }
                PropertyChanges { target: middlePanel; visible: false }
                PropertyChanges { target: titleBar; basicButtonVisible: false }
                PropertyChanges { target: wizard; visible: true }
                PropertyChanges { target: appWindow; width: 930; }
                PropertyChanges { target: appWindow; height: 595; }
                PropertyChanges { target: resizeArea; visible: false }
                PropertyChanges { target: titleBar; maximizeButtonVisible: false }
                PropertyChanges { target: frameArea; blocked: true }
                PropertyChanges { target: titleBar; visible: false }
                PropertyChanges { target: titleBar; y: 0 }
                PropertyChanges { target: titleBar; title: qsTr("Program setup wizard") + translationManager.emptyString }
            }, State {
                name: "normal"
                PropertyChanges { target: leftPanel; visible: true }
                PropertyChanges { target: rightPanel; visible: true }
                PropertyChanges { target: middlePanel; visible: true }
                PropertyChanges { target: titleBar; basicButtonVisible: true }
                PropertyChanges { target: wizard; visible: false }
                PropertyChanges { target: appWindow; width: rightPanelExpanded ? 1269 : 1269 - 300; }
                PropertyChanges { target: appWindow; height: maxWindowHeight; }
                PropertyChanges { target: resizeArea; visible: true }
                PropertyChanges { target: titleBar; maximizeButtonVisible: true }
                PropertyChanges { target: frameArea; blocked: false }
                PropertyChanges { target: titleBar; visible: true }
                PropertyChanges { target: titleBar; y: 0 }
                PropertyChanges { target: titleBar; title: qsTr("Monero") + translationManager.emptyString }
            }
        ]

        LeftPanel {
            id: leftPanel
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: parent.height
            onDashboardClicked: middlePanel.state = "Dashboard"
            onTransferClicked: middlePanel.state = "Transfer"
            onReceiveClicked: middlePanel.state = "Receive"
            onTxkeyClicked: middlePanel.state = "TxKey"
            onHistoryClicked: middlePanel.state = "History"
            onAddressBookClicked: middlePanel.state = "AddressBook"
            onMiningClicked: middlePanel.state = "Mining"
            onSignClicked: middlePanel.state = "Sign"
            onSettingsClicked: middlePanel.state = "Settings"
        }

        RightPanel {
            id: rightPanel
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height
            width: appWindow.rightPanelExpanded ? 300 : 0
            visible: appWindow.rightPanelExpanded
        }


        MiddlePanel {
            id: middlePanel
            anchors.bottom: parent.bottom
            anchors.left: leftPanel.visible ?  leftPanel.right : parent.left
            anchors.right: rightPanel.left
            height: parent.height
            state: "Transfer"
        }

        TipItem {
            id: tipItem
            text: qsTr("send to the same destination") + translationManager.emptyString
            visible: false
        }

        MouseArea {
            id: frameArea
            property bool blocked: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            z: 1
            hoverEnabled: true
            propagateComposedEvents: true
            onPressed: mouse.accepted = false
            onReleased: mouse.accepted = false
            onMouseXChanged: titleBar.mouseX = mouseX
            onContainsMouseChanged: titleBar.containsMouse = containsMouse
        }

        SequentialAnimation {
            id: goToBasicAnimation
            PropertyAction {
                target: appWindow
                properties: "visibility"
                value: Window.Windowed
            }
            PropertyAction {
                target: titleBar
                properties: "maximizeButtonVisible"
                value: false
            }
            PropertyAction {
                target: frameArea
                properties: "blocked"
                value: true
            }
            PropertyAction {
                target: resizeArea
                properties: "visible"
                value: false
            }
            NumberAnimation {
                target: appWindow
                properties: "height"
                to: 30
                easing.type: Easing.InCubic
                duration: 200
            }
            NumberAnimation {
                target: appWindow
                properties: "width"
                to: 470
                easing.type: Easing.InCubic
                duration: 200
            }
            PropertyAction {
                targets: [leftPanel, rightPanel]
                properties: "visible"
                value: false
            }
            PropertyAction {
                target: middlePanel
                properties: "basicMode"
                value: true
            }

            NumberAnimation {
                target: appWindow
                properties: "height"
                to: middlePanel.height
                easing.type: Easing.InCubic
                duration: 200
            }

            onStopped: {
                // middlePanel.visible = false
                rightPanel.visible = false
                leftPanel.visible = false
            }
        }

        SequentialAnimation {
            id: goToProAnimation
            NumberAnimation {
                target: appWindow
                properties: "height"
                to: 30
                easing.type: Easing.InCubic
                duration: 200
            }
            PropertyAction {
                target: middlePanel
                properties: "basicMode"
                value: false
            }
            PropertyAction {
                targets: [leftPanel, middlePanel, rightPanel, resizeArea]
                properties: "visible"
                value: true
            }
            NumberAnimation {
                target: appWindow
                properties: "width"
                to: rightPanelExpanded ? 1269 : 1269 - 300
                easing.type: Easing.InCubic
                duration: 200
            }
            NumberAnimation {
                target: appWindow
                properties: "height"
                to: maxWindowHeight
                easing.type: Easing.InCubic
                duration: 200
            }
            PropertyAction {
                target: frameArea
                properties: "blocked"
                value: false
            }
            PropertyAction {
                target: titleBar
                properties: "maximizeButtonVisible"
                value: true
            }
        }

        WizardMain {
            id: wizard
            anchors.fill: parent
            onUseMoneroClicked: {
                rootItem.state = "normal" // TODO: listen for this state change in appWindow;
                appWindow.initialize();
            }
            onOpenWalletFromFileClicked: {
                rootItem.state = "normal" // TODO: listen for this state change in appWindow;
                appWindow.openWalletFromFile();
            }
        }

        property int maxWidth: leftPanel.width + 655 + rightPanel.width
        property int minHeight: 720
        MouseArea {
            id: resizeArea
            hoverEnabled: true
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 30
            width: 30

            Rectangle {
                anchors.fill: parent
                color: parent.containsMouse || parent.pressed ? "#111111" : "transparent"
            }

            Image {
                anchors.centerIn: parent
                source: parent.containsMouse || parent.pressed ? "images/resizeHovered.png" :
                                                                 "images/resize.png"
            }

            property var previousPosition

            onPressed: {
                previousPosition = globalCursor.getPosition()
            }

            onPositionChanged: {
                if(!pressed) return
                var pos = globalCursor.getPosition()
                //var delta = previousPosition - pos
                var dx = previousPosition.x - pos.x
                var dy = previousPosition.y - pos.y

                if(appWindow.width - dx > parent.maxWidth)
                    appWindow.width -= dx
                else appWindow.width = parent.maxWidth

                if(appWindow.height - dy > parent.minHeight)
                    appWindow.height -= dy
                else appWindow.height = parent.minHeight
                previousPosition = pos
            }
        }

        TitleBar {
            id: titleBar
            anchors.left: parent.left
            anchors.right: parent.right
            x: 0
            y: 0
            customDecorations: persistentSettings.customDecorations
            onGoToBasicVersion: {
                if (yes) {
                    // basicPanel.currentView = middlePanel.currentView
                    goToBasicAnimation.start()
                } else {
                    // middlePanel.currentView = basicPanel.currentView
                    goToProAnimation.start()
                }
            }

            MouseArea {
                enabled: persistentSettings.customDecorations
                property var previousPosition
                anchors.fill: parent
                propagateComposedEvents: true
                onPressed: previousPosition = globalCursor.getPosition()
                onPositionChanged: {
                    if (pressedButtons == Qt.LeftButton) {
                        var pos = globalCursor.getPosition()
                        var dx = pos.x - previousPosition.x
                        var dy = pos.y - previousPosition.y

                        appWindow.x += dx
                        appWindow.y += dy
                        previousPosition = pos
                    }
                }
            }
        }

        // new ToolTip
        Rectangle {
            id: toolTip
            property alias text: content.text
            width: content.width + 12
            height: content.height + 17
            color: "#FF6C3C"
            //radius: 3
            visible:false;

            Image {
                id: tip
                anchors.top: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 5
                source: "../images/tip.png"
            }

            Text {
                id: content
                anchors.horizontalCenter: parent.horizontalCenter
                y: 6
                lineHeight: 0.7
                font.family: "Arial"
                font.pixelSize: 12
                font.letterSpacing: -1
                color: "#FFFFFF"
            }
        }

    }
    onClosing: {
        // Close wallet non async on exit
        walletManager.closeWallet();
        // Stop daemon and pool miner
        daemonManager.stop();
    }
}
