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

		putContentUnderTitle: true

		name: "Theme"
		description: "Color scheme, corner radius, spacing & text customization."

		Column {
			spacing: Settings.spacing.small

			StyledButtonGroup {
				id: themeButtonGroup
				exclusive: true

				onCheckedButtonsUpdated: () => {
					if (checkedButtons[0]) {
						Settings.raw.appearance.activeTheme = checkedButtons[0].modelData.name
						Settings.reloadTheme()
					}
				}
			}

			Repeater {
				model: Settings.raw.appearance.themes

				StyledButton {
					id: themeButton

					required property int index
					required property var modelData

					implicitWidth: parent.parent.parent.width

					rightPadding: Settings.spacing.medium

					checkable: true
					checked: modelData.name === Settings.theme.name
					buttonGroup: themeButtonGroup
					firstInSequence: index === 0
					lastInSequence: index === Settings.raw.appearance.themes.length - 1

					backgroundColor: Settings.palette.background0

					contentItem: RowLayout {
						spacing: Settings.spacing.medium

						StyledText {
							Layout.fillWidth: true
							Layout.horizontalStretchFactor: 1

							text: modelData.name
							color: themeButton.checked ? Settings.palette.background1 : Settings.palette.foreground0

							Behavior on color {
								ColorAnimation {
									duration: Settings.animationSpeed.normal
									easing.type: Settings.animationEasing.easeOut
								}
							}
						}

						RowLayout {
							Layout.fillHeight: true
							Layout.preferredWidth: 200
							Layout.minimumWidth: 100
							Layout.maximumWidth: 200
							spacing: 0

							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.background0

								topLeftRadius: Settings.radius.small
								bottomLeftRadius: Settings.radius.small
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.background1
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.background2
							}

							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.foreground0
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.foreground1
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.foreground2
							}

							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.accent
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.border
							}

							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.red
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.orange
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.yellow
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.green
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.cyan
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.blue
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.violet
							}
							Rectangle {
								Layout.fillWidth: true
								Layout.fillHeight: true

								color: modelData.palette.pink

								topRightRadius: Settings.radius.small
								bottomRightRadius: Settings.radius.small
							}
						}
					}
				}
			}
		}
	}

	Setting {
		implicitWidth: parent.parent.width

		name: "Animation Speed Multiplier"
		description: "Change the speed of all animations."

		content: RowLayout {
			spacing: Settings.spacing.medium

			StyledText {
				text: `${Math.round(animationSpeedMultiplierSlider.value * 100)}%`
			}

			StyledSlider {
				id: animationSpeedMultiplierSlider

				step: 0.1
				value: Settings.raw.appearance.multipliers.animationSpeedMultiplier
				minValue: 0.0
				maxValue: 10.0
				snapPoints: [ 2.0, 4.0, 6.0, 8.0 ]
				snapThreshold: 0.4

				gutterColor: Settings.palette.background0

				onMoved: (newValue) => {
					value = newValue
					Settings.raw.appearance.multipliers.animationSpeedMultiplier = newValue
					Settings.reloadTheme()
				}
			}
		}
	}
}