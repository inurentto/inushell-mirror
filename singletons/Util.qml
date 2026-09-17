pragma Singleton

import Quickshell



Singleton {
    function mod(a, b) {
        return ((a % b) + b) % b
    }

    function clamp(a, min, max) {
        return Math.min(Math.max(a, min), max)
    }

    function mutliplyColors(a: color, b: color) {
        return Qt.rgba(
            a.r * b.r,
            a.g * b.g,
            a.b * b.b,
            a.a * b.a
        )
    }
}