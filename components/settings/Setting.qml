import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.components



WrapperRectangle {
	property string name: ""
	property string description: ""

	property bool putContentUnderTitle: false

	default property Component content

	margin: Settings.spacing.big

	color: Settings.palette.background1
	radius: Settings.radius.big

	Item {
		id: contentItem

		implicitWidth: parent.width - parent.margin * 2
		implicitHeight: childrenRect.height

		Column {
			spacing: Settings.spacing.big

			Column {
				spacing: Settings.spacing.small
				
				StyledText {
					text: name

					font.pointSize: Settings.fontSize.smallTitle
					font.bold: true

					visible: name !== ""
				}

				StyledText {
					text: description
					color: Settings.palette.foreground2

					font.pointSize: Settings.fontSize.small

					visible: description !== ""
				}
			}

			Loader {
				width: contentItem.width

				active: putContentUnderTitle
				sourceComponent: content
			}
		}

		Loader {
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter

			active: !putContentUnderTitle
			sourceComponent: content
		}
	}
}