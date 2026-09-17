import QtQuick
import QtQuick.Layouts

import qs.services
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
        spacing: Settings.spacing.small

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

                topLeftCornerRadius: index == 0 ? Settings.radius.medium : Settings.radius.small
                topRightCornerRadius: index == repeater.count - 1 ? Settings.radius.medium : Settings.radius.small
                bottomLeftCornerRadius: index == 0 ? Settings.radius.medium : Settings.radius.small
                bottomRightCornerRadius: index == repeater.count - 1 ? Settings.radius.medium : Settings.radius.small

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