import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.resources
import qs.widgets
import qs.widgets.controls



Item {
    id: root

    // Input
    default property list<ButtonBarItem> children

    // Behavior
    property bool enabled: true
    property bool toggleable: false

    // Layout
    property bool vertical: false

    // State
    property int selectedIndex: toggleable ? 0 : -1

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    RowLayout {
        spacing: Config.theme.spacing.small

        Repeater {
            id: repeater

            model: root.children

            Button {
                id: button

                required property int index
                required property ButtonBarItem modelData

                enabled: root.enabled && modelData.enabled

                toggleable: root.toggleable
                isToggled: root.selectedIndex == index

                topLeftCornerRadius: index == 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                topRightCornerRadius: index == repeater.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                bottomLeftCornerRadius: index == 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                bottomRightCornerRadius: index == repeater.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small

                onClicked: () => {
                    if (toggleable) root.selectedIndex = index

                    for (var otherIndex = 0; otherIndex < repeater.count; otherIndex++) {
                        let button = repeater.itemAt(otherIndex)
                        button.isToggled = root.selectedIndex == otherIndex
                    }
                }

                content: modelData.content
            }
        }
    }
}