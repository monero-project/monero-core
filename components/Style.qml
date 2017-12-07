pragma Singleton

import QtQuick 2.5

QtObject {
    property QtObject fontMedium: FontLoader { id: _fontMedium; source: "qrc:/fonts/SFUIDisplay-Medium.otf"; }
    property QtObject fontBold: FontLoader { id: _fontBold; source: "qrc:/fonts/SFUIDisplay-Bold.otf"; }
    property QtObject fontLight: FontLoader { id: _fontLight; source: "qrc:/fonts/SFUIDisplay-Light.otf"; }
    property QtObject fontRegular: FontLoader { id: _fontRegular; source: "qrc:/fonts/SFUIDisplay-Regular.otf"; }

    property string defaultFontColor: "white"
    property string inputBoxBackground: "black"
    property string inputBoxBackgroundError: "#FFDDDD"
    property string inputBoxColor: "white"

    property string buttonBackgroundColor: "#FA6800"
    property string buttonBackgroundColorHover: "#E65E00"
    property string buttonBackgroundColorDisabled: "#3B3B3B"
    property string buttonBackgroundColorDisabledHover: "#4F4F4F"

    property string buttonTextColor: "white"
    property string buttonTextColorDisabled: "black"
    property string dividerColor: "white"
    property real dividerOpacity: 0.25
}
