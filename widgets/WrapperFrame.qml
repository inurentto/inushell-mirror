import Quickshell.Widgets

import qs.singletons



WrapperRectangle {
    id: root

    property alias leftPadding: root.leftMargin
    property alias rightPadding: root.rightMargin
    property alias topPadding: root.topMargin
    property alias bottomPadding: root.bottomMargin

    color: Config.theme.getBackground1( )

    border {
        width: 0
        color: Config.theme.getBorder( )
    }
}