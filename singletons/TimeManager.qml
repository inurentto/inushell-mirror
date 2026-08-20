pragma Singleton

import Quickshell



Singleton {
    id: root

    readonly property date rawDateTime: clock.date
    readonly property string formattedTime: {
        Qt.formatDateTime(rawDateTime, "hh:mm:ss")
    }
    readonly property string formattedDate: {
        Qt.formatDateTime(rawDateTime, "yyyy-MM-dd")
    }
    readonly property string formattedTimeLong: {
        Qt.formatDateTime(rawDateTime, "hh:mm:ss t")
    }
    readonly property string formattedDateLong: {
        Qt.formatDateTime(rawDateTime, "MMMM d yyyy")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}