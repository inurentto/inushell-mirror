pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick



Singleton {
    id: root

    enum ClockModuleDisplayBehavior { Full, Hover, Toggle }

    property bool interfaceOpen: false

    readonly property string settingsPath: "/home/inurentto/.config/inushell/settings.json"

    property var _theme: raw.appearance.themes.find(theme => theme.name === raw.appearance.activeTheme)
    readonly property var theme: _theme
    readonly property var palette: theme.palette
    readonly property QtObject spacing: QtObject {
        readonly property int small: theme.spacing.small
        readonly property int medium: theme.spacing.medium
        readonly property int big: theme.spacing.big
    }
    readonly property QtObject radius: QtObject {
        readonly property int small: theme.radius.small
        readonly property int medium: theme.radius.medium
        readonly property int big: theme.radius.big
    }
    readonly property QtObject fonts: QtObject {
        readonly property string main: theme.fonts.main
        readonly property string mono: theme.fonts.mono
    }
    readonly property QtObject fontSize: QtObject {
        readonly property int normal: theme.fontSize.normal
        readonly property int small: theme.fontSize.small

        readonly property int bigTitle: theme.fontSize.bigTitle
        readonly property int smallTitle: theme.fontSize.smallTitle
    }
    readonly property QtObject animationSpeed: QtObject {
        readonly property real fast: theme.animation.speed.fast * raw.appearance.multipliers.animationSpeedMultiplier
        readonly property real normal: theme.animation.speed.normal * raw.appearance.multipliers.animationSpeedMultiplier
        readonly property real slow: theme.animation.speed.slow * raw.appearance.multipliers.animationSpeedMultiplier
    }
    readonly property var animationEasing: theme.animation.easing

    readonly property QtObject clockModule: QtObject {
        readonly property var displayBehavior: raw.modules.clock.displayBehavior
    }

    readonly property JsonAdapter raw: settingsData

    function reloadTheme(): void {
        _theme = settingsData.appearance.themes.find(theme => theme.name === settingsData.appearance.activeTheme)
    }

    JsonAdapter {
        id: settingsData
        property JsonObject appearance: JsonObject {
            property string activeTheme: "Catppuccin Mocha"
            property list<var> themes: [
                {
                    name: "Catppuccin Mocha",

                    palette: {
                        background0: "#181825",
                        background1: "#1e1e2e",
                        background2: "#313244",

                        foreground0: "#cdd6f4",
                        foreground1: "#bac2de",
                        foreground2: "#585b70",

                        accent: "#b4befe",
                        border: "#45475a",

                        red: "#f38ba8",
                        orange: "#fab387",
                        yellow: "#f9e2af",
                        green: "#a6e3a1",
                        cyan: "#94e2d5",
                        blue: "#89b4fa",
                        violet: "#cba6f7",
                        pink: "#f5c2e7",
                    },

                    spacing: {
                        small: 4,
                        medium: 8,
                        big: 16
                    },
                    radius: {
                        small: 4,
                        medium: 8,
                        big: 16
                    },

                    fonts: {
                        main: "JetBrainsMono Nerd Font Propo",
                        mono: "JetBrainsMono Nerd Font Mono"
                    },
                    fontSize: {
                        normal: 11,
                        small: 10,

                        bigTitle: 24,
                        smallTitle: 13
                    },

                    animation: {
                        speed: {
                            fast: 50,
                            normal: 150,
                            slow: 300
                        },
                        easing: {
                            easeIn: Easing.InQuint,
                            easeOut: Easing.OutQuint,
                            easeInOut: Easing.InOutQuint
                        }
                    }
                },
                {
                    name: "Catppuccin Latte",
                    palette: {
                        background0: "#dce0e8",
                        background1: "#eff1f5",
                        background2: "#bcc0cc",

                        foreground0: "#4c4f69",
                        foreground1: "#5c5f77",
                        foreground2: '#a8acc0',

                        accent: "#7287fd",
                        border: "#7c7f93",

                        red: "#d20f39",
                        orange: "#fe640b",
                        yellow: "#df8e1d",
                        green: "#40a02b",
                        cyan: "#04a5e5",
                        blue: "#1e66f5",
                        violet: "#8839ef",
                        pink: "#dd7878",
                    },

                    spacing: {
                        small: 4,
                        medium: 8,
                        big: 16
                    },
                    radius: {
                        small: 4,
                        medium: 8,
                        big: 16
                    },

                    fonts: {
                        main: "JetBrainsMono Nerd Font Propo",
                        mono: "JetBrainsMono Nerd Font Mono"
                    },
                    fontSize: {
                        normal: 11,
                        small: 10,

                        bigTitle: 24,
                        smallTitle: 13
                    },

                    animation: {
                        speed: {
                            fast: 50,
                            normal: 150,
                            slow: 300
                        },
                        easing: {
                            easeIn: Easing.InQuint,
                            easeOut: Easing.OutQuint,
                            easeInOut: Easing.InOutQuint
                        }
                    }
                },
                {
                    name: "Chalk",
                    palette: {
                        background0: "#151515",
                        background1: "#202020",
                        background2: "#303030",

                        foreground0: "#e0e0e0",
                        foreground1: '#dfdfdf',
                        foreground2: '#808080',

                        accent: '#bdbdbd',
                        border: "#505050",

                        red: "#fb9fb1",
                        orange: "#eda987",
                        yellow: "#ddb26f",
                        green: "#acc267",
                        cyan: "#12cfc0",
                        blue: "#6fc2ef",
                        violet: '#b179f1',
                        pink: '#ef8ced',
                    },

                    spacing: {
                        small: 4,
                        medium: 8,
                        big: 16
                    },
                    radius: {
                        small: 0,
                        medium: 0,
                        big: 0
                    },

                    fonts: {
                        main: "Rubik",
                        mono: "JetBrainsMono Nerd Font Mono"
                    },
                    fontSize: {
                        normal: 11,
                        small: 10,

                        bigTitle: 24,
                        smallTitle: 15
                    },

                    animation: {
                        speed: {
                            fast: 50,
                            normal: 150,
                            slow: 300
                        },
                        easing: {
                            easeIn: Easing.InQuint,
                            easeOut: Easing.OutQuint,
                            easeInOut: Easing.InOutQuint
                        }
                    }
                }
            ]
            property JsonObject multipliers: JsonObject {
                property real animationSpeedMultiplier: 1
            }
        }
        property JsonObject modules: JsonObject {
            property JsonObject clock: JsonObject {
                property int displayBehavior: Settings.ClockModuleDisplayBehavior.Full
            }
        }
    }

    FileView {
        path: settingsPath
        watchChanges: true
        adapter: settingsData

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        Component.onCompleted: () => {
            writeAdapter()
        }
    }
}