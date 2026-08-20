import Quickshell
import QtQuick

import qs.singletons
import qs.resources



ButtonBarItem {
    required property QsWindow window

    property Component panelContent: null

    signal opened( )

    function getContentX( ): real {
        return content.parent !== null ? content.parent.mapToItem( null, 0, 0 ).x : 0
    }
    function getContentWidth( ): real {
        return content.parent !== null ? content.parent.width : 0
    }
}