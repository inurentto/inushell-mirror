import QtQuick

import qs.components.controls



QtObject {
    id: root

    property ListModel buttons: ListModel {}
    property list<StyledAbstractButton> checkedButtons: []
    property bool exclusive: false

    function setCheckedOnButtons(checked: bool): void {
        for (let index = 0; index < buttons.count; index++) {
            const button = buttons.get(index).button
            button.checked = checked
        }
    }

    function updateCheckedButtons(): list<StyledAbstractButton> {
        const checked = []
        for (let index = 0; index < buttons.count; index++) {
            const button = buttons.get(index).button
            if (button.checked) checked.push(button)
        }

        checkedButtons = checked
        root.checkedButtonsUpdated()
    }

    signal checkedButtonsUpdated()

    Component.onCompleted: () => {
        let hasCheckedButton = false
        for (let index = 0; index < buttons.count; index++) {
            const button = buttons.get(index)
            button.buttonGroup = this

            if (exclusive) {
                if (hasCheckedButton) button.checked = false
                else if (button.checked) hasCheckedButton = true
            }
        }
    }
}