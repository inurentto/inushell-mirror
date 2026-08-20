import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import qs.singletons
import qs.utils
import qs.widgets
import qs.widgets.controls
import qs.widgets.launcher



Scope {
    id: root

    LazyLoader {
        id: interfaceLoader

        activeAsync: false

        PanelWindow {
            id: interfaceWindow

            property list<QtObject> results: []

            anchors {
                bottom: true
            }

            exclusionMode: ExclusionMode.Ignore

            color: "transparent"

            mask: Region { item: contentContainer }

            implicitWidth: 768 + Config.theme.spacing.big * 2
            implicitHeight: 548 + Config.theme.spacing.big * 2

            WlrLayershell.layer: WlrLayer.Overlay

            focusable: true
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            Component.onCompleted: () => {
                searchField.text = ""
                interfaceWindow.refreshResults()
                searchField.forceActiveFocus()

                openAnimation.start()
            }
            
            function refreshResults(): void {
                resultsListView.currentIndex = 0

                const searchResults = searcher.query(searchField.text)
                try {
                    const evalResult = eval?.(searchField.text) // Using ?. to call eval indirectly, otherwise eval has access to variables like interfaceWindow.width
                    if ( evalResult != undefined && evalResult !== "" ) {
                        var evaluatedEntry = evaluationHolder.createObject(interfaceWindow, { result: evalResult })

                        searchResults.unshift(evaluatedEntry)
                    }
                } catch (_) {}

                interfaceWindow.results = searchResults
            }

            function close(): void {
                closeAnimation.start()
            }

            function executeEntry(entry: QtObject): void {
                if (entry instanceof DesktopEntry) {
                    if (entry.runInTerminal) {
                        terminalProcess.exec({
                            command: [ "alacritty", "--command", entry.execString ],
                            workingDirectory: entry.workingDirectory
                        })
                    } else {
                        entry.execute()
                    }
                } else if (entry instanceof EvaluatedEntry) {
                    Quickshell.clipboardText = entry.result
                }
            }

            function getEntryTitleText(entry: QtObject): string {
                if (entry instanceof DesktopEntry) {
                    return entry.name
                } else if (entry instanceof EvaluatedEntry) {
                    return entry.result
                }
            }

            function getEntryDescriptionText(entry: QtObject): string {
                if (entry instanceof DesktopEntry) {
                    return entry.genericName
                } else if (entry instanceof EvaluatedEntry) {
                    return "Evaluated expression, copy to clipboard."
                }
            }

            Process {
                id: terminalProcess
            }

            Timer {
                id: refreshTimer
            }

            Searcher {
                id: searcher
                list: DesktopEntries.applications.values
                useFuzzy: false
            }

            ClippingWrapperRectangle {
                id: contentContainer

                property real yOffset: interfaceWindow.height

                readonly property real listImplicitHeight: resultsListView.contentHeight + contentLayout.spacing
                readonly property real contentHeight: contentLayout.childrenRect.height - resultsListView.height + listImplicitHeight

                x: Config.theme.spacing.big
                y: interfaceWindow.height - height + yOffset - Config.theme.spacing.big

                implicitWidth: interfaceWindow.width - Config.theme.spacing.big * 2
                implicitHeight: Math.min(interfaceWindow.height - Config.theme.spacing.big * 2, contentHeight)

                topMargin: Config.theme.padding.normal
                bottomMargin: Config.theme.padding.normal
                leftMargin: Config.theme.padding.normal
                rightMargin: Config.theme.padding.normal

                color: Config.theme.getBackground0()

                radius: Config.theme.cornerRadius.big

                Behavior on implicitHeight {
                    PropertyAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }

                ParallelAnimation {
                    id: openAnimation
                    PropertyAnimation {
                        target: contentContainer
                        property: "yOffset"
                        from: interfaceWindow.height
                        to: 0
                        duration: Config.theme.animationSpeed.normal
                        easing.type: Config.theme.easingType
                    }
                    PropertyAnimation {
                        target: contentContainer
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: Config.theme.animationSpeed.normal
                        easing.type: Config.theme.easingType
                    }
                }

                SequentialAnimation {
                    id: closeAnimation
                    ParallelAnimation {
                        PropertyAnimation {
                            target: contentContainer
                            property: "yOffset"
                            to: interfaceWindow.height
                            duration: Config.theme.animationSpeed.normal
                            easing.type: Config.theme.easingType
                        }
                        PropertyAnimation {
                            target: contentContainer
                            property: "opacity"
                            to: 0
                            duration: Config.theme.animationSpeed.normal
                            easing.type: Config.theme.easingType
                        }
                    }
                    PropertyAction { target: interfaceLoader; property: "activeAsync"; value: false }
                }

                ColumnLayout {
                    id: contentLayout

                    spacing: Config.theme.spacing.big

                    StyledListView {
                        id: resultsListView
                        model: interfaceWindow.results

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        clip: true

                        reuseItems: false

                        highlightMoveDuration: Config.theme.animationSpeed.veryFast

                        orientation: Qt.Vertical

                        keyNavigationWraps: true

                        delegate: AppItem {
                            required property var modelData
                            required property int index

                            implicitWidth: resultsListView.width

                            app: modelData
                            highlighted: resultsListView.currentIndex == index

                            topLeftCornerRadius: index === 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                            topRightCornerRadius: index === 0 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                            bottomLeftCornerRadius: index === resultsListView.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small
                            bottomRightCornerRadius: index === resultsListView.count - 1 ? Config.theme.cornerRadius.normal : Config.theme.cornerRadius.small

                            onClicked: () => {
                                interfaceWindow.executeEntry(modelData)
                                interfaceWindow.close()
                            }
                        }

                        ScrollBar.vertical: ScrollBar {}
                    }

                    Text {
                        id: noResultsIndicator

                        Layout.fillWidth: true
                        
                        text: "No results :("
                        color: Config.theme.getForeground2()
                        horizontalAlignment: Text.AlignHCenter

                        visible: interfaceWindow.results.length === 0
                    }

                    Separator {
                        id: separator
                        Layout.fillWidth: true
                    }

                    TextField {
                        id: searchField

                        implicitWidth: contentContainer.width - borderWidth * 4 - contentContainer.leftMargin - contentContainer.rightMargin
                        implicitHeight: 48

                        placeholderText: "Search..."

                        font.pointSize: Config.theme.textSize.smallTitle

                        onAccepted: {
                            if (interfaceWindow.results.length > 0) {
                                interfaceWindow.executeEntry(interfaceWindow.results[resultsListView.currentIndex]);
                                interfaceWindow.close();
                            }
                        }

                        onTextEdited: {
                            interfaceWindow.refreshResults();
                        }

                        onUnfocusRequested: () => {
                            interfaceWindow.close();
                        }

                        Keys.onPressed: (event) => {
                            if (interfaceWindow.results.length > 0) {
                                switch (event.key) {
                                    case Qt.Key_Up: resultsListView.decrementCurrentIndex(); break
                                    case Qt.Key_Down: resultsListView.incrementCurrentIndex(); break
                                }
                            }
                        }
                    }
                }
            }

            MultiEffect {
                source: contentContainer
                anchors.fill: contentContainer
                shadowEnabled: true
                shadowBlur: 1.0
                blurMax: 16
                shadowColor: Qt.rgba(0, 0, 0, Config.theme.shadowOpacity)
            }
        }
    }

    IpcHandler {
        target: "launcher"

        function open(): void {
            interfaceLoader.activeAsync = true;
        }
    }

    component EvaluatedEntry: QtObject {
        property string result: "N/A"
    }

    Component {
        id: evaluationHolder

        EvaluatedEntry {}
    }
}