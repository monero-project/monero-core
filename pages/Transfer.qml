// Copyright (c) 2014-2018, The Monero Project
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
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import moneroComponents.Clipboard 1.0
import moneroComponents.PendingTransaction 1.0
import moneroComponents.Wallet 1.0
import "../components"
import "." 1.0


Rectangle {
    id: root
    signal paymentClicked(string address, string paymentId, string amount, int mixinCount,
                          int priority, string description)
    signal sweepUnmixableClicked()

    color: "transparent"
    property string startLinkText: qsTr("<style type='text/css'>a {text-decoration: none; color: #FF6C3C; font-size: 14px;}</style><font size='2'> (</font><a href='#'>Start daemon</a><font size='2'>)</font>") + translationManager.emptyString
    property bool showAdvanced: false

    Clipboard { id: clipboard }

    function scaleValueToMixinCount(scaleValue) {
        var scaleToMixinCount = [6,7,8,9,10,11,12,13,14,16,18,20,22,25];
        if (scaleValue < scaleToMixinCount.length) {
            return scaleToMixinCount[scaleValue];
        } else {
            return 0;
        }
    }

    function isValidOpenAliasAddress(address) {
      address = address.trim()
      var dot = address.indexOf('.')
      if (dot < 0)
        return false
      // we can get an awful lot of valid domains, including non ASCII chars... accept anything
      return true
    }

    function oa_message(text) {
      oaPopup.title = qsTr("OpenAlias error") + translationManager.emptyString
      oaPopup.text = text
      oaPopup.icon = StandardIcon.Information
      oaPopup.onCloseCallback = null
      oaPopup.open()
    }

    function updateMixin() {
        var fillLevel = (isMobile) ? privacyLevelItemSmall.fillLevel : privacyLevelItem.fillLevel
        var mixin = scaleValueToMixinCount(fillLevel)
        console.log("PrivacyLevel changed:"  + fillLevel)
        console.log("mixin count: "  + mixin)
        privacyLabel.text = qsTr("Privacy level (ringsize %1)").arg(mixin+1) + translationManager.emptyString
    }

    function updateFromQrCode(address, payment_id, amount, tx_description, recipient_name) {
        console.log("updateFromQrCode")
        addressLine.text = address
        paymentIdLine.text = payment_id
        amountLine.text = amount
        descriptionLine.text = recipient_name + " " + tx_description
        cameraUi.qrcode_decoded.disconnect(updateFromQrCode)
    }

    function clearFields() {
        addressLine.text = ""
        paymentIdLine.text = ""
        amountLine.text = ""
        descriptionLine.text = ""
    }

    // Information dialog
    StandardDialog {
        // dynamically change onclose handler
        property var onCloseCallback
        id: oaPopup
        cancelVisible: false
        onAccepted:  {
            if (onCloseCallback) {
                onCloseCallback()
            }
        }
    }

    ColumnLayout {
      id: pageRoot
      anchors.margins: (isMobile)? 17 : 20
      anchors.topMargin: 40 * scaleRatio

      anchors.left: parent.left
      anchors.top: parent.top
      anchors.right: parent.right

      spacing: 26 * scaleRatio

      GridLayout {
          columns: (isMobile)? 1 : 2
          Layout.fillWidth: true
          columnSpacing: 32

          ColumnLayout {
              Layout.fillWidth: true

              RowLayout {
                  Layout.fillWidth: true
                  id: amountRow
                  Layout.minimumWidth: 200

                  // Amount input
                  LineEdit {
                      id: amountLine
                      Layout.fillWidth: true
                      inlineIcon: true
                      labelText: qsTr("Amount") + translationManager.emptyString
                      placeholderText: qsTr("") + translationManager.emptyString
                      width: 100
                      inlineButtonText: qsTr("All") + translationManager.emptyString
                      inlineButton.onClicked: amountLine.text = "(all)"
                      validator: DoubleValidator {
                          bottom: 0.0
                          top: 18446744.073709551615
                          decimals: 12
                          notation: DoubleValidator.StandardNotation
                          locale: "C"
                      }
                  }
              }
          }

          ColumnLayout {
              Layout.fillWidth: true
              Label {
                  id: transactionPriority
                  text: qsTr("Transaction priority") + translationManager.emptyString
              }
              // Note: workaround for translations in listElements
              // ListElement: cannot use script for property value, so
              // code like this wont work:
              // ListElement { column1: qsTr("LOW") + translationManager.emptyString ; column2: ""; priority: PendingTransaction.Priority_Low }
              // For translations to work, the strings need to be listed in
              // the file components/StandardDropdown.qml too.

              // Priorites after v5
              ListModel {
                   id: priorityModelV5

                   ListElement { column1: qsTr("Default") ; column2: ""; priority: 0}
                   ListElement { column1: qsTr("Slow (x0.25 fee)") ; column2: ""; priority: 1}
                   ListElement { column1: qsTr("Normal (x1 fee)") ; column2: ""; priority: 2 }
                   ListElement { column1: qsTr("Fast (x5 fee)") ; column2: ""; priority: 3 }
                   ListElement { column1: qsTr("Fastest (x41.5 fee)")  ; column2: "";  priority: 4 }
               }

              StandardDropdown {
                  Layout.fillWidth: true
                  id: priorityDropdown
                  shadowReleasedColor: "#FF4304"
                  shadowPressedColor: "#B32D00"
                  releasedColor: "#363636"
                  pressedColor: "#202020"
              }
          }
          // Make sure dropdown is on top
          z: parent.z + 1
      }

      // recipient address input
      RowLayout {
          id: addressLineRow
          Layout.fillWidth: true

          LineEditMulti{
              id: addressLine
              spacing: 0
              inputLabelText: qsTr("<style type='text/css'>a {text-decoration: none; color: #858585; font-size: 14px;}</style>\
                Address <font size='2'>  ( </font> <a href='#'>Address book</a><font size='2'> )</font>")
                + translationManager.emptyString
              labelButtonText: qsTr("Resolve") + translationManager.emptyString
              placeholderText: "4.."
              onInputLabelLinkActivated: { appWindow.showPageRequest("AddressBook") }
              onLabelButtonClicked: {
                  var result = walletManager.resolveOpenAlias(addressLine.text)
                  if (result) {
                    var parts = result.split("|")
                    if (parts.length == 2) {
                      var address_ok = walletManager.addressValid(parts[1], appWindow.persistentSettings.testnet)
                      if (parts[0] === "true") {
                        if (address_ok) {
                          addressLine.text = parts[1]
                          addressLine.cursorPosition = 0
                        }
                        else
                          oa_message(qsTr("No valid address found at this OpenAlias address"))
                      } else if (parts[0] === "false") {
                        if (address_ok) {
                          addressLine.text = parts[1]
                          addressLine.cursorPosition = 0
                          oa_message(qsTr("Address found, but the DNSSEC signatures could not be verified, so this address may be spoofed"))
                        } else {
                          oa_message(qsTr("No valid address found at this OpenAlias address, but the DNSSEC signatures could not be verified, so this may be spoofed"))
                        }
                      } else {
                        oa_message(qsTr("Internal error"))
                      }
                    } else {
                      oa_message(qsTr("Internal error"))
                    }
                  } else {
                    oa_message(qsTr("No address found"))
                  }
              }
          }

          StandardButton {
              id: qrfinderButton
              text: qsTr("QR Code") + translationManager.emptyString
              visible : appWindow.qrScannerEnabled
              enabled : visible
              width: visible ? 60 * scaleRatio : 0
              onClicked: {
                  cameraUi.state = "Capture"
                  cameraUi.qrcode_decoded.connect(updateFromQrCode)
              }
          }
      }

      RowLayout {
          // payment id input
          LineEdit {
              id: paymentIdLine
              labelText: qsTr("Payment ID <font size='2'>( Optional )</font>") + translationManager.emptyString
              placeholderText: qsTr("16 or 64 hexadecimal characters") + translationManager.emptyString
              Layout.fillWidth: true
          }
      }

      RowLayout {
          LineEdit {
              id: descriptionLine
              labelText: qsTr("Description <font size='2'>( Optional )</font>") + translationManager.emptyString
              placeholderText: qsTr("Saved to local wallet history") + translationManager.emptyString
              Layout.fillWidth: true
          }
      }

      RowLayout {
          StandardButton {
              id: sendButton
              Layout.bottomMargin: 17 * scaleRatio
              Layout.topMargin: 17 * scaleRatio
              text: qsTr("Send") + translationManager.emptyString
              enabled : !appWindow.viewOnly && pageRoot.checkInformation(amountLine.text, addressLine.text, paymentIdLine.text, appWindow.persistentSettings.testnet)
              onClicked: {
                  console.log("Transfer: paymentClicked")
                  var priority = priorityModelV5.get(priorityDropdown.currentIndex).priority
                  console.log("priority: " + priority)
                  console.log("amount: " + amountLine.text)
                  addressLine.text = addressLine.text.trim()
                  paymentIdLine.text = paymentIdLine.text.trim()
                  root.paymentClicked(addressLine.text, paymentIdLine.text, amountLine.text, scaleValueToMixinCount(privacyLevelItem.fillLevel),
                                 priority, descriptionLine.text)

              }
          }
      }

      function checkInformation(amount, address, payment_id, nettype) {
        address = address.trim()
        payment_id = payment_id.trim()

        var amount_ok = amount.length > 0
        var address_ok = walletManager.addressValid(address, nettype)
        var payment_id_ok = payment_id.length == 0 || walletManager.paymentIdValid(payment_id)
        var ipid = walletManager.paymentIdFromAddress(address, nettype)
        if (ipid.length > 0 && payment_id.length > 0)
           payment_id_ok = false

        addressLine.error = !address_ok
        amountLine.error = !amount_ok
        paymentIdLine.error = !payment_id_ok

        return amount_ok && address_ok && payment_id_ok
      }

    } // pageRoot

    Rectangle {
        id:desaturate
        color:"black"
        anchors.fill: parent
        opacity: 0.1
        visible: (pageRoot.enabled)? 0 : 1;
    }

    ColumnLayout {
        anchors.top: pageRoot.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: (isMobile)? 17 : 20
        anchors.topMargin: 40 * scaleRatio
        spacing: 26 * scaleRatio
        enabled: !viewOnly || pageRoot.enabled

        RowLayout {
            CheckBox {
                id: showAdvancedCheckbox
                checked: persistentSettings.transferShowAdvanced
                onClicked: {
                    persistentSettings.transferShowAdvanced = !persistentSettings.transferShowAdvanced
                }
                text: qsTr("Show advanced options") + translationManager.emptyString
            }
        }

        Rectangle {
            visible: persistentSettings.transferShowAdvanced
            Layout.fillWidth: true
            height: 1
            color: Style.dividerColor
            opacity: Style.dividerOpacity
            Layout.bottomMargin: 30 * scaleRatio
        }

        RowLayout {
            visible: persistentSettings.transferShowAdvanced
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.fillWidth: true
            Label {
                id: privacyLabel
                fontSize: 14
                text: ""
            }

            Label {
                id: costLabel
                fontSize: 14
                text: qsTr("Transaction cost") + translationManager.emptyString
                anchors.right: parent.right
            }
        }

        PrivacyLevel {
            visible: persistentSettings.transferShowAdvanced && !isMobile
            id: privacyLevelItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 17 * scaleRatio
            onFillLevelChanged: updateMixin()
        }

        PrivacyLevelSmall {
            visible: persistentSettings.transferShowAdvanced && isMobile
            id: privacyLevelItemSmall
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 17 * scaleRatio
            onFillLevelChanged: updateMixin()
        }


        GridLayout {
            visible: persistentSettings.transferShowAdvanced
            Layout.topMargin: 50 * scaleRatio


            columns: (isMobile) ? 2 : 6

            StandardButton {
                id: sweepUnmixableButton
                text: qsTr("Sweep Unmixable") + translationManager.emptyString
                enabled : pageRoot.enabled
                onClicked: {
                    console.log("Transfer: sweepUnmixableClicked")
                    root.sweepUnmixableClicked()
                }
            }

            StandardButton {
                id: saveTxButton
                text: qsTr("Create tx file") + translationManager.emptyString
                visible: appWindow.viewOnly
                enabled: pageRoot.checkInformation(amountLine.text, addressLine.text, paymentIdLine.text, appWindow.persistentSettings.nettype)
                onClicked: {
                    console.log("Transfer: saveTx Clicked")
                    var priority = priorityModelV5.get(priorityDropdown.currentIndex).priority
                    console.log("priority: " + priority)
                    console.log("amount: " + amountLine.text)
                    addressLine.text = addressLine.text.trim()
                    paymentIdLine.text = paymentIdLine.text.trim()
                    root.paymentClicked(addressLine.text, paymentIdLine.text, amountLine.text, scaleValueToMixinCount(privacyLevelItem.fillLevel),
                                   priority, descriptionLine.text)

                }
            }

            StandardButton {
                id: signTxButton
                text: qsTr("Sign tx file") + translationManager.emptyString
                visible: !appWindow.viewOnly
                onClicked: {
                    console.log("Transfer: sign tx clicked")
                    signTxDialog.open();
                }
            }

            StandardButton {
                id: submitTxButton
                text: qsTr("Submit tx file") + translationManager.emptyString
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                visible: appWindow.viewOnly
                enabled: pageRoot.enabled
                onClicked: {
                    console.log("Transfer: submit tx clicked")
                    submitTxDialog.open();
                }
            }
        }


    }



    //SignTxDialog
    FileDialog {
        id: signTxDialog
        title: qsTr("Please choose a file") + translationManager.emptyString
        folder: "file://" +moneroAccountsDir
        nameFilters: [ "Unsigned transfers (*)"]

        onAccepted: {
            var path = walletManager.urlToLocalPath(fileUrl);
            // Load the unsigned tx from file
            var transaction = currentWallet.loadTxFile(path);

            if (transaction.status !== PendingTransaction.Status_Ok) {
                console.error("Can't load unsigned transaction: ", transaction.errorString);
                informationPopup.title = qsTr("Error") + translationManager.emptyString;
                informationPopup.text  = qsTr("Can't load unsigned transaction: ") + transaction.errorString
                informationPopup.icon  = StandardIcon.Critical
                informationPopup.onCloseCallback = null
                informationPopup.open();
                // deleting transaction object, we don't want memleaks
                transaction.destroy();
            } else {
                    confirmationDialog.text =  qsTr("\nNumber of transactions: ") + transaction.txCount
                for (var i = 0; i < transaction.txCount; ++i) {
                    confirmationDialog.text += qsTr("\nTransaction #%1").arg(i+1)
                    +qsTr("\nRecipient: ") + transaction.recipientAddress[i]
                    + (transaction.paymentId[i] == "" ? "" : qsTr("\n\payment ID: ") + transaction.paymentId[i])
                    + qsTr("\nAmount: ") + walletManager.displayAmount(transaction.amount(i))
                    + qsTr("\nFee: ") + walletManager.displayAmount(transaction.fee(i))
                    + qsTr("\nRingsize: ") + transaction.mixin(i+1)

                    // TODO: add descriptions to unsigned_tx_set?
    //              + (transactionDescription === "" ? "" : (qsTr("\n\nDescription: ") + transactionDescription))
                    + translationManager.emptyString
                    if (i > 0) {
                        confirmationDialog.text += "\n\n"
                    }

                }

                console.log(transaction.confirmationMessage);

                // Show confirmation dialog
                confirmationDialog.title = qsTr("Confirmation") + translationManager.emptyString
                confirmationDialog.icon = StandardIcon.Question
                confirmationDialog.onAcceptedCallback = function() {
                    transaction.sign(path+"_signed");
                    transaction.destroy();
                };
                confirmationDialog.onRejectedCallback = transaction.destroy;

                confirmationDialog.open()
            }

        }
        onRejected: {
            // File dialog closed
            console.log("Canceled")
        }
    }

    //SignTxDialog
    FileDialog {
        id: submitTxDialog
        title: qsTr("Please choose a file") + translationManager.emptyString
        folder: "file://" +moneroAccountsDir
        nameFilters: [ "signed transfers (*)"]

        onAccepted: {
            if(!currentWallet.submitTxFile(walletManager.urlToLocalPath(fileUrl))){
                informationPopup.title = qsTr("Error") + translationManager.emptyString;
                informationPopup.text  = qsTr("Can't submit transaction: ") + currentWallet.errorString
                informationPopup.icon  = StandardIcon.Critical
                informationPopup.onCloseCallback = null
                informationPopup.open();
            } else {
                informationPopup.title = qsTr("Information") + translationManager.emptyString
                informationPopup.text  = qsTr("Money sent successfully") + translationManager.emptyString
                informationPopup.icon  = StandardIcon.Information
                informationPopup.onCloseCallback = null
                informationPopup.open();
            }
        }
        onRejected: {
            console.log("Canceled")
        }

    }

    Rectangle {
        x: root.width/2 - width/2
        y: root.height/2 - height/2
        height:statusText.paintedHeight + 50 * scaleRatio
        width:statusText.paintedWidth + 40 * scaleRatio
        visible: statusText.text != ""
        opacity: 0.9

        Text {
            id: statusText
            anchors.fill:parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.RichText
            onLinkActivated: { appWindow.startDaemon(appWindow.persistentSettings.daemonFlags); }
        }
    }

    Component.onCompleted: {
        //Disable password page until enabled by updateStatus
        pageRoot.enabled = false
    }

    // fires on every page load
    function onPageCompleted() {
        console.log("transfer page loaded")
        updateStatus();
        updateMixin();
        updatePriorityDropdown()
    }

    function updatePriorityDropdown() {
        priorityDropdown.dataModel = priorityModelV5;
        priorityDropdown.currentIndex = 0
        priorityDropdown.update()
    }

    //TODO: Add daemon sync status
    //TODO: enable send page when we're connected and daemon is synced

    function updateStatus() {
        if(typeof currentWallet === "undefined") {
            statusText.text = qsTr("Wallet is not connected to daemon.") + "<br>" + root.startLinkText
            return;
        }

        if (currentWallet.viewOnly) {
           // statusText.text = qsTr("Wallet is view only.")
           //return;
        }
        pageRoot.enabled = false;

        switch (currentWallet.connected()) {
        case Wallet.ConnectionStatus_Disconnected:
            statusText.text = qsTr("Wallet is not connected to daemon.") + "<br>" + root.startLinkText
            break
        case Wallet.ConnectionStatus_WrongVersion:
            statusText.text = qsTr("Connected daemon is not compatible with GUI. \n" +
                                   "Please upgrade or connect to another daemon")
            break
        default:
            if(!appWindow.daemonSynced){
                statusText.text = qsTr("Waiting on daemon synchronization to finish")
            } else {
                // everything OK, enable transfer page
                // Light wallet is always ready
                pageRoot.enabled = true;
                statusText.text = "";
            }

        }
    }

    // Popuplate fields from addressbook.
    function sendTo(address, paymentId, description){
        addressLine.text = address
        paymentIdLine.text = paymentId
        descriptionLine.text = description
    }
}
