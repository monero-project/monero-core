// Copyright (c) 2014-2020, The Monero Project
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

import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

import "../components" as MoneroComponents
import FontAwesome 1.0

Rectangle {
    id: root
    x: parent.width/2 - root.width/2
    y: parent.height/2 - root.height/2
    z: parent.z + 1
    // TODO: implement without hardcoding sizes
    width: 580
    height: 400
    color: MoneroComponents.Style.blackTheme ? "black" : "white"
    visible: false
    radius: 10
    border.color: MoneroComponents.Style.blackTheme ? Qt.rgba(255, 255, 255, 0.25) : Qt.rgba(0, 0, 0, 0.25)
    border.width: 1
    focus: true
    Keys.enabled: true
    Keys.onEscapePressed: {
        root.close()
        root.clearFields()
        root.rejected()
    }
    Keys.onEnterPressed: {
         if (root.state == "default") {
             root.close()
             root.accepted()
         } else if (root.state == "error") {
             root.close()
             root.clearFields()
             root.rejected()
         }
    }
    Keys.onReturnPressed: {
         if (root.state == "default") {
             root.close()
             root.accepted()
         } else if (root.state == "error") {
             root.close()
             root.clearFields()
             root.rejected()
         }
    }
    KeyNavigation.tab: confirmButton

    property var transactionAmount: ""
    property var transactionAddress: ""
    property var transactionDescription: ""
    property var transactionFee: ""
    property var transactionPriority: ""
    property bool sweepUnmixable: false
    property alias errorText: errorText
    property alias confirmButton: confirmButton
    property alias backButton: backButton
    property alias bottomText: bottomText
    property alias bottomTextAnimation: bottomTextAnimation

    state: "default"
    states: [
        State {
            // waiting for user action, show tx details + back and confirm buttons
            name: "default";
            when: errorText.text =="" && bottomText.text ==""
            PropertyChanges { target: errorText; visible: false }
            PropertyChanges { target: txAmountText; visible: root.transactionAmount !== "(all)" || (root.transactionAmount === "(all)" && currentWallet.isHwBacked() === true) }
            PropertyChanges { target: txAmountBusyIndicator; visible: !txAmountText.visible }
            PropertyChanges { target: txFiatAmountText; visible: txAmountText.visible && persistentSettings.fiatPriceEnabled && root.transactionAmount !== "(all)" }
            PropertyChanges { target: txDetails; visible: true }
            PropertyChanges { target: bottom; visible: true }
            PropertyChanges { target: bottomMessage; visible: false }
            PropertyChanges { target: buttons; visible: true }
            PropertyChanges { target: backButton; visible: true; primary: false }
            PropertyChanges { target: confirmButton; visible: true }
        }, State {
            // error message being displayed, show only back button
            name: "error";
            when: errorText.text !==""
            PropertyChanges { target: dialogTitle; text: "Error" }
            PropertyChanges { target: errorText; visible: true }
            PropertyChanges { target: txAmountText; visible: false }
            PropertyChanges { target: txAmountBusyIndicator; visible: false }
            PropertyChanges { target: txFiatAmountText; visible: false }
            PropertyChanges { target: txDetails; visible: false }
            PropertyChanges { target: bottom; visible: true }
            PropertyChanges { target: bottomMessage; visible: false }
            PropertyChanges { target: buttons; visible: true }
            PropertyChanges { target: backButton; visible: true; primary: true }
            PropertyChanges { target: confirmButton; visible: false }
        }, State {
            // creating or sending transaction, show tx details and don't show any button
            name: "bottomText";
            when: errorText.text =="" && bottomText.text !==""
            PropertyChanges { target: errorText; visible: false }
            PropertyChanges { target: txAmountText; visible: root.transactionAmount !== "(all)" || (root.transactionAmount === "(all)" && currentWallet.isHwBacked() === true) }
            PropertyChanges { target: txAmountBusyIndicator; visible: !txAmountText.visible }
            PropertyChanges { target: txFiatAmountText; visible: txAmountText.visible && persistentSettings.fiatPriceEnabled && root.transactionAmount !== "(all)" }
            PropertyChanges { target: txDetails; visible: true }
            PropertyChanges { target: bottom; visible: true }
            PropertyChanges { target: bottomMessage; visible: true }
            PropertyChanges { target: buttons; visible: false }
        }
    ]

    // same signals as Dialog has
    signal accepted()
    signal rejected()

    function open() {
        root.visible = true;

        //clean previous error message
        errorText.text = "";
        root.forceActiveFocus()
    }

    function close() {
        root.visible = false;
    }

    function clearFields() {
        root.transactionAmount = "";
        root.transactionAddress = "";
        root.transactionDescription = "";
        root.transactionFee = "";
        root.transactionPriority = "";
        root.sweepUnmixable = false;
    }

    function showFiatConversion(valueXMR) {
        return (fiatApiConvertToFiat(valueXMR) === "0.00" ? "<0.01 " + fiatApiCurrencySymbol() : "~" + fiatApiConvertToFiat(valueXMR) + " " + fiatApiCurrencySymbol());
    }

    ColumnLayout {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 25

        RowLayout {
            Layout.topMargin: 10
            Layout.fillWidth: true

            MoneroComponents.Label {
                id: dialogTitle
                Layout.fillWidth: true
                fontSize: 18
                fontFamily: "Arial"
                horizontalAlignment: Text.AlignHCenter
                text: {
                    if (appWindow.viewOnly) {
                        return "Create transaction file" + translationManager.emptyString;
                    } else if (root.sweepUnmixable) {
                        return "Sweep unmixable outputs" + translationManager.emptyString;
                    } else {
                        return "Confirm send" + translationManager.emptyString;
                    }
                }
            }
        }

        Text {
            id: errorText
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: MoneroComponents.Style.defaultFontColor
            wrapMode: Text.Wrap
            font.pixelSize: 15
        }

        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.preferredHeight: 71

            BusyIndicator {
                  id: txAmountBusyIndicator
                  Layout.fillWidth: true
                  Layout.alignment : Qt.AlignTop | Qt.AlignLeft
                  running: root.transactionAmount == "(all)"
            }

            Text {
                id: txAmountText
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: root.transactionAmount == "(all)" && currentWallet.isHwBacked() === true ? 32 : 42
                color: MoneroComponents.Style.defaultFontColor
                text: {
                    if (root.transactionAmount == "(all)" && currentWallet.isHwBacked() === true) {
                        return "All unlocked balance" +  translationManager.emptyString;
                    } else {
                        return root.transactionAmount + " XMR " +  translationManager.emptyString;
                    }
                }
            }

            Text {
                id: txFiatAmountText
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: MoneroComponents.Style.buttonSecondaryTextColor
                text: showFiatConversion(transactionAmount) + translationManager.emptyString
            }
        }

        GridLayout {
            columns: 2
            id: txDetails
            Layout.fillWidth: true
            columnSpacing: 15
            rowSpacing: 16

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                Text {
                    Layout.fillWidth: true
                    color: MoneroComponents.Style.dimmedFontColor
                    text: qsTr("From:") + translationManager.emptyString
                    font.pixelSize: 15
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: 15
                    color: MoneroComponents.Style.defaultFontColor
                    text: {
                        if (currentWallet) {
                            var walletTitle = function() {
                                if (currentWallet.isLedger()) {
                                    return "Ledger";
                                } else if (currentWallet.isTrezor()) {
                                    return "Trezor";
                                } else {
                                    return qsTr("My wallet");
                                }
                            }
                            var walletName = appWindow.walletName;
                            if (appWindow.currentWallet.numSubaddressAccounts() > 1) {
                                var currentSubaddressAccount = currentWallet.currentSubaddressAccount;
                                var currentAccountLabel =  currentWallet.getSubaddressLabel(currentWallet.currentSubaddressAccount, 0);
                                return walletTitle() + " (" + walletName + ")" + "<br>" + qsTr("Account #") + currentSubaddressAccount + (currentAccountLabel !== "" ? " (" + currentAccountLabel + ")" : "") + translationManager.emptyString;
                            } else {
                                return walletTitle() + " (" + walletName + ")" + translationManager.emptyString;
                            }
                        } else {
                            return "";
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: 15
                    color: MoneroComponents.Style.dimmedFontColor
                    text: qsTr("To:") + translationManager.emptyString
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: 15
                    font.family: MoneroComponents.Style.fontRegular.name
                    textFormat: Text.RichText
                    wrapMode: Text.Wrap
                    color: MoneroComponents.Style.defaultFontColor
                    text: {
                        if (root.transactionAddress) {
                            const addressBookName = currentWallet ? currentWallet.addressBook.getDescription(root.transactionAddress) : null;
                            var fulladdress = root.transactionAddress;
                            var spacedaddress = fulladdress.match(/.{1,4}/g);
                            var spacedaddress = spacedaddress.join(' ');
                            if (!addressBookName) {
                                return qsTr("Monero address") + "<br>" + spacedaddress + translationManager.emptyString; 
                            } else {
                                return FontAwesome.addressBook + " " + addressBookName + "<br>" + spacedaddress;
                            }
                        } else {
                            return "";
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                Text {
                    Layout.fillWidth: true
                    color: MoneroComponents.Style.dimmedFontColor
                    text: qsTr("Fee:") + translationManager.emptyString
                    font.pixelSize: 15
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    color: MoneroComponents.Style.defaultFontColor
                    font.pixelSize: 15
                    text: {
                        if (currentWallet) {
                            if (!root.transactionFee) {
                                if (currentWallet.isHwBacked() === true) {
                                    return "See on device" +  translationManager.emptyString;
                                } else {
                                    return "Calculating fee..." +  translationManager.emptyString;
                                }
                            } else {
                                return root.transactionFee + " XMR"
                            }
                        } else {
                            return "";
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    color: MoneroComponents.Style.buttonSecondaryTextColor
                    visible: persistentSettings.fiatPriceEnabled && root.transactionFee
                    font.pixelSize: 15
                    text: showFiatConversion(root.transactionFee)
                }
            }
        }

        ColumnLayout {
            id: bottom
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            Layout.fillWidth: true

            RowLayout {
                id: bottomMessage
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                BusyIndicator {
                    visible: !bottomTextAnimation.running
                    running: !bottomTextAnimation.running
                    scale: .5
                }

                Text {
                    id: bottomText
                    color: MoneroComponents.Style.defaultFontColor
                    text: ""
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    font.pixelSize: 17
                    opacity: 1

                    SequentialAnimation{
                        id:bottomTextAnimation
                        running: false
                        loops: Animation.Infinite
                        alwaysRunToEnd: true
                        NumberAnimation { target: bottomText; property: "opacity"; to: 0; duration: 500}
                        NumberAnimation { target: bottomText; property: "opacity"; to: 1; duration: 500}
                    }
                }
            }

            RowLayout {
                id: buttons
                spacing: 70
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                MoneroComponents.StandardButton {
                    id: backButton
                    text: qsTr("Back") + translationManager.emptyString;
                    width: 200
                    focus: false
                    primary: false
                    KeyNavigation.tab: confirmButton
                    Keys.enabled: backButton.visible
                    Keys.onReturnPressed: backButton.onClicked
                    Keys.onEnterPressed: backButton.onClicked
                    Keys.onEscapePressed: {
                        root.close()
                        root.clearFields()
                        root.rejected()
                    }
                    onClicked: {
                        root.close()
                        root.clearFields()
                        root.rejected()
                    }
                }

                MoneroComponents.StandardButton {
                    id: confirmButton
                    text: qsTr("Confirm") + translationManager.emptyString;
                    rightIcon: "qrc:///images/rightArrow.png"
                    width: 200
                    focus: false
                    KeyNavigation.tab: backButton
                    Keys.enabled: confirmButton.visible
                    Keys.onReturnPressed: confirmButton.onClicked
                    Keys.onEnterPressed: confirmButton.onClicked
                    Keys.onEscapePressed: {
                        root.close()
                        root.clearFields()
                        root.rejected()
                    }
                    onClicked: {
                        root.close()
                        root.accepted()
                    }
                }
            }
        }
    }
}
