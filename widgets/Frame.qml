import QtQuick

import qs.singletons



Rectangle {
    color: Config.theme.getBackground1( )

    border {
        width: Config.theme.borderWidth.normal
        color: Config.theme.getBorder( )
    }
}