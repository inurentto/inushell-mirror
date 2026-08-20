pragma Singleton

import Quickshell
import QtQuick



Singleton {
    id: root

    enum ClockModuleBehavior { Full, Hover, Toggle }

    readonly property int barHeight: 30

    readonly property int notificationWidth: 512

    readonly property var modules: ({
        clock: {
            behavior: Config.ClockModuleBehavior.Full
        }
    })

    readonly property var theme: ({
        background0: "base01",
        background1: "base00",
        background2: "base02",

        foreground0: "base06",
        foreground1: "base05",
        foreground2: "base04",

        border: "base03",
        accent: "base07",

        red: "base08",
        orange: "base09",
        yellow: "base0A",
        green: "base0B",
        cyan: "base0C",
        blue: "base0D",
        violet: "base0E",
        pink: "base0F",

        shadowOpacity: 0.75,

        colorScheme: root.colorSchemes.catppuccinMocha,
        mainFont: "JetBrainsMono Nerd Font Mono",
        monoFont: "JetBrainsMono Nerd Font Mono",

        getBackground0: () => root.theme.colorScheme[root.theme.background0],
        getBackground1: () => root.theme.colorScheme[root.theme.background1],
        getBackground2: () => root.theme.colorScheme[root.theme.background2],

        getForeground0: () => root.theme.colorScheme[root.theme.foreground0],
        getForeground1: () => root.theme.colorScheme[root.theme.foreground1],
        getForeground2: () => root.theme.colorScheme[root.theme.foreground2],

        getBorder: () => root.theme.colorScheme[root.theme.border],
        getAccent: () => root.theme.colorScheme[root.theme.accent],

        getRed: () => root.theme.colorScheme[root.theme.red],
        getOrange: () => root.theme.colorScheme[root.theme.orange],
        getYellow: () => root.theme.colorScheme[root.theme.yellow],
        getGreen: () => root.theme.colorScheme[root.theme.green],
        getCyan: () => root.theme.colorScheme[root.theme.cyan],
        getBlue: () => root.theme.colorScheme[root.theme.blue],
        getViolet: () => root.theme.colorScheme[root.theme.violet],
        getPink: () => root.theme.colorScheme[root.theme.accent],

        easingType: Easing.OutQuint,

        animationSpeed: {
            ludicrous: 50,
            veryFast: 75,
            fast: 100,
            normal: 250,
            slow: 400
        },
        
        borderWidth: {
            normal: 2
        },

        cornerRadius: {
            small: 4,
            normal: 8,
            big: 16
        },

        padding: {
            small: 4,
            normal: 8,
            big: 16
        },

        spacing: {
            small: 4,
            normal: 8,
            big: 16,
            veryBig: 32
        },

        textSize: {
            smallTitle: 13,
            normal: 11,
            small: 10
        }
    })

    readonly property var colorSchemes: ({
        wallust: {
            base00: "#1E1E2E",
            base01: "#1B1B29",
            base02: "#353543",
            base03: "#585B70",
            base04: "#A4ABC3",
            base05: "#B9C1DC",
            base06: "#CDD6F4",
            base07: "#A4B6F4",
            base08: "#F38BA8",
            base09: "#A6E3A1",
            base0A: "#F9E2AF",
            base0B: "#89B4FA",
            base0C: "#F5C2E7",
            base0D: "#94E2D5",
            base0E: "#BAC2DE",
            base0F: "#585B70"
        },

        ayuDark: {
            base00: "#0b0e14",
            base01: "#131721",
            base02: "#202229",
            base03: "#3e4b59",
            base04: "#bfbdb6",
            base05: "#e6e1cf",
            base06: "#ece8db",
            base07: "#f2f0e7",
            base08: "#f07178",
            base09: "#ff8f40",
            base0A: "#ffb454",
            base0B: "#aad94c",
            base0C: "#95e6cb",
            base0D: "#59c2ff",
            base0E: "#d2a6ff",
            base0F: "#e6b450"
        },

        catppuccinMocha: {
            base00: "#1e1e2e",
            base01: "#181825",
            base02: "#313244",
            base03: "#45475a",
            base04: "#585b70",
            base05: "#cdd6f4",
            base06: "#f5e0dc",
            base07: "#b4befe",
            base08: "#f38ba8",
            base09: "#fab387",
            base0A: "#f9e2af",
            base0B: "#a6e3a1",
            base0C: "#94e2d5",
            base0D: "#89b4fa",
            base0E: "#cba6f7",
            base0F: "#f2cdcd"
        }
    })
}