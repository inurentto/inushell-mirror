import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.components
import qs.components.controls
import qs.components.settings



ColumnLayout {
	spacing: Settings.spacing.big

	Setting {
		implicitWidth: parent.parent.width

		name: "Display Behavior"
		description: "How the time is displayed."

		content: RowLayout {
			spacing: Settings.spacing.small

			StyledButtonGroup {
				id: buttonGroup
				exclusive: true
			}

			StyledButton {
				id: fullOption

				text: "Full"

				checkable: true
				checked: Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Full
				buttonGroup: buttonGroup

				backgroundColor: Settings.palette.background0

				onClicked: () => {
					if (checked) Settings.raw.modules.clock.displayBehavior = Settings.ClockModuleDisplayBehavior.Full
				}
			}
			StyledButton {
				id: hoverOption

				text: "Hover"

				checkable: true
				checked: Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Hover
				buttonGroup: buttonGroup

				backgroundColor: Settings.palette.background0
				
				onClicked: () => {
					if (checked) Settings.raw.modules.clock.displayBehavior = Settings.ClockModuleDisplayBehavior.Hover
				}
			}
			StyledButton {
				id: toggleOption

				text: "Toggle"

				checkable: true
				checked: Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Toggle
				buttonGroup: buttonGroup

				backgroundColor: Settings.palette.background0

				onClicked: () => {
					if (checked) Settings.raw.modules.clock.displayBehavior = Settings.ClockModuleDisplayBehavior.Toggle
				}
			}
		}
	}
}