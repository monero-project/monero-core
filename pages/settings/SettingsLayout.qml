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

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

import "../../js/Utils.js" as Utils
import "../../js/Windows.js" as Windows
import "../../components" as MoneroComponents

Rectangle {
    color: "transparent"
    height: 1400
    Layout.fillWidth: true

    function onPageCompleted() {
        userInactivitySliderTimer.running = true;
    }

    function onPageClosed() {
        userInactivitySliderTimer.running = false;
    }

    ColumnLayout {
        id: settingsUI
        property int itemHeight: 60 * scaleRatio
        Layout.fillWidth: true
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: (isMobile)? 17 * scaleRatio : 20 * scaleRatio
        anchors.topMargin: 0
        spacing: 6 * scaleRatio

        MoneroComponents.CheckBox {
            visible: !isMobile
            id: customDecorationsCheckBox
            checked: persistentSettings.customDecorations
            onClicked: Windows.setCustomWindowDecorations(checked)
            text: qsTr("Custom decorations") + translationManager.emptyString
        }

        MoneroComponents.CheckBox {
            visible: !isMobile
            id: hideBalanceCheckBox
            checked: persistentSettings.hideBalance
            onClicked: {
                persistentSettings.hideBalance = !persistentSettings.hideBalance
                appWindow.updateBalance();
            }
            text: qsTr("Hide balance") + translationManager.emptyString
        }

        MoneroComponents.CheckBox {
            visible: !isMobile
            id: showPidCheckBox
            checked: persistentSettings.showPid
            onClicked: {
                persistentSettings.showPid = !persistentSettings.showPid
            }
            text: qsTr("Enable transfer with payment ID (OBSOLETE)") + translationManager.emptyString
        }

        MoneroComponents.CheckBox {
            visible: !isMobile
            id: userInActivityCheckbox
            checked: persistentSettings.lockOnUserInActivity
            onClicked: persistentSettings.lockOnUserInActivity = !persistentSettings.lockOnUserInActivity
            text: qsTr("Lock wallet on inactivity") + translationManager.emptyString
        }

        MoneroComponents.CheckBox {
            id: themeCheckbox
            checked: !MoneroComponents.Style.blackTheme
            text: qsTr("Light theme") + translationManager.emptyString
            onClicked: {
                MoneroComponents.Style.blackTheme = !MoneroComponents.Style.blackTheme;
                persistentSettings.blackTheme = MoneroComponents.Style.blackTheme;
            }
        }

        ColumnLayout {
            visible: userInActivityCheckbox.checked
            Layout.fillWidth: true
            Layout.topMargin: 6 * scaleRatio
            Layout.leftMargin: 42 * scaleRatio
            spacing: 0

            MoneroComponents.TextBlock {
                font.pixelSize: 14 * scaleRatio
                Layout.fillWidth: true
                text: {
                    var val = userInactivitySlider.value;
                    var minutes = val > 1 ? qsTr("minutes") : qsTr("minute");

                    qsTr("After ") + val + " " + minutes + translationManager.emptyString;
                }
            }

            Slider {
                id: userInactivitySlider
                from: 1
                value: persistentSettings.lockOnUserInActivityInterval
                to: 60
                leftPadding: 0
                stepSize: 1
                snapMode: Slider.SnapAlways

                background: Rectangle {
                    x: parent.leftPadding
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    implicitWidth: 200 * scaleRatio
                    implicitHeight: 4 * scaleRatio
                    width: parent.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: MoneroComponents.Style.progressBarBackgroundColor

                    Rectangle {
                        width: parent.visualPosition * parent.width
                        height: parent.height
                        color: MoneroComponents.Style.green
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    implicitWidth: 18 * scaleRatio
                    implicitHeight: 18 * scaleRatio
                    radius: 8
                    color: parent.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: MoneroComponents.Style.grey
                }
            }

            Timer {
                // @TODO: Slider.onMoved{} is available in Qt > 5.9, use a hacky timer for now
                id: userInactivitySliderTimer
                interval: 1000; running: false; repeat: true
                onTriggered: {
                    if(persistentSettings.lockOnUserInActivityInterval != userInactivitySlider.value) {
                        persistentSettings.lockOnUserInActivityInterval = userInactivitySlider.value;
                    }
                }
            }
        }

        //! Manage pricing
        RowLayout {
            MoneroComponents.CheckBox {
                visible: builtWithPrices
                id: enableConvertCurrency
                text: qsTr("Enable displaying balance in other currencies") + translationManager.emptyString
                checked: persistentSettings.enableCurrencyConversion
                onCheckedChanged: {
                    persistentSettings.enableCurrencyConversion = checked;
                    appWindow.setPriceManager(checked);
                }
            }
        }

        GridLayout {
            visible: builtWithPrices && enableConvertCurrency.checked
            columns: (isMobile)? 1 : 2
            Layout.fillWidth: true
            columnSpacing: 32

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                MoneroComponents.Label {
                    Layout.fillWidth: true
                    text: qsTr("Price source") + translationManager.emptyString
                }

                MoneroComponents.StandardDropdown {
                    id: priceSourceDropDown
                    dataModel: priceManager.priceSourcesAvailableModel
                    currentIndex: appWindow.persistentSettings.currencyConversionSourceIndex
                    onChanged: {
                        var idx = dataModel.index(currentIndex, 0);
                        priceManager.setPriceSource(idx);
                        appWindow.persistentSettings.currencyConversionSourceIndex = currentIndex;
                    }
                    Layout.fillWidth: true
                    shadowReleasedColor: "#FF4304"
                    shadowPressedColor: "#B32D00"
                    releasedColor: "#363636"
                    pressedColor: "#202020"

                    function update() {
                        colText = dataModel.getLabelAt(currentIndex);
                    }
                }
            }

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                MoneroComponents.Label {
                    Layout.fillWidth: true
                    text: qsTr("Currency") + translationManager.emptyString
                }

                MoneroComponents.StandardDropdown {
                    id: currencyDropDown
                    dataModel: priceManager.currenciesAvailableModel
                    currentIndex: appWindow.persistentSettings.currencyConversionCurrencyIndex
                    onChanged: {
                        var idx = dataModel.index(currentIndex, 0);
                        priceManager.setCurrency(idx);
                        appWindow.persistentSettings.currencyConversionCurrencyIndex = currentIndex;
                    }
                    Layout.fillWidth: true
                    shadowReleasedColor: "#FF4304"
                    shadowPressedColor: "#B32D00"
                    releasedColor: "#363636"
                    pressedColor: "#202020"

                    function update() {
                        colText = dataModel.getLabelAt(currentIndex);
                    }
                }

                // Make sure dropdown is on top
            }

            ColumnLayout {
                Layout.fillWidth: true
            }

            z: parent.z + 1
        }

        MoneroComponents.StandardButton {
            visible: !persistentSettings.customDecorations
            Layout.topMargin: 10 * scaleRatio
            small: true
            text: qsTr("Change language") + translationManager.emptyString

            onClicked: {
                appWindow.toggleLanguageView();
            }
        }

        MoneroComponents.TextBlock {
            visible: isMobile
            font.pixelSize: 14
            textFormat: Text.RichText
            Layout.fillWidth: true
            text: qsTr("No Layout options exist yet in mobile mode.") + translationManager.emptyString;
        }
    }

    Component.onCompleted: {
        priceSourceDropDown.currentIndex = appWindow.persistentSettings.currencyConversionSourceIndex;
        priceSourceDropDown.update();
        currencyDropDown.currentIndex = appWindow.persistentSettings.currencyConversionCurrencyIndex;
        currencyDropDown.update();
        console.log('SettingsLayout loaded');
    }
}

