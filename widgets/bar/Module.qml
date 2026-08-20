import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.resources



Item {
    id: root
    implicitWidth: childrenRect.width
    implicitHeight: parent.height

    enum AnchorPosition {
        Left,
        Right,
        Center
    }

    required property QsWindow window

    property int anchorPosition: Module.AnchorPosition.Left

    property bool enabled: false

    property list<ModuleArea> areas
    readonly property bool noAreasVisible: {
        let areaVisible = false
        for (let index = 0; index < areas.length; index++) {
            const area = areas[index]
            if (area.enabled) {
                areaVisible = true
                break
            }
        }

        return areaVisible
    }
    
    signal clicked( MouseEvent mouse, ModuleArea area, int index )
    signal wheel( WheelEvent wheel, ModuleArea area, int index )
    signal entered( ModuleArea area, int index )
    signal exited( ModuleArea area, int index )

    clip: false

    RowLayout {
        spacing: Config.theme.spacing.small

        Repeater {
            id: repeater

            model: ScriptModel {
                values: areas.filter(entry => entry.enabled)
            }

            Button {
                required property int index
                required property ModuleArea modelData
                content: modelData.content

                implicitWidth: {
                    if ( modelData.aspectRatio ) {
                        return implicitHeight / modelData.aspectRatio
                    }
                }
                implicitHeight: root.height

                wheelEnabled: true

                acceptedButtons: modelData.acceptedButtons

                topPadding: modelData.topPadding
                bottomPadding: modelData.bottomPadding
                leftPadding: modelData.leftPadding
                rightPadding: modelData.rightPadding

                topLeftCornerRadius: index === 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                topRightCornerRadius: index === repeater.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                bottomLeftCornerRadius: index === 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                bottomRightCornerRadius: index === repeater.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small

                backgroundColor: modelData.backgroundColor
                backgroundHoverColor: modelData.backgroundHoverColor
                backgroundPressColor: modelData.backgroundPressColor
                borderColor: modelData.borderColor
                borderHoverColor: modelData.backgroundHoverColor
                borderPressColor: modelData.backgroundPressColor

                cursorShape: modelData.cursorShape

                onClicked: ( mouse ) => root.clicked( mouse, modelData, index )
                onWheel: ( wheel ) => root.wheel( wheel, modelData, index )
                onEntered: ( ) => {
                    if ( modelData.panelContent !== null ) PanelManager.openPanel( modelData )
                    else PanelManager.forceClosePanel( )
                    root.entered( modelData, index )
                }
                onExited: ( ) => {
                    if ( modelData.panelContent !== null ) PanelManager.panelFocusLost( )
                    root.exited( modelData, index )
                }
            }
        }
    }
}