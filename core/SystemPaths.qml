pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: paths

    ////////////////////////////////////////////////////////
    // GPU
    ////////////////////////////////////////////////////////

    readonly property string gpuBusy:
        "/sys/class/drm/card1/device/gpu_busy_percent"

    ////////////////////////////////////////////////////////
    // /proc Files
    ////////////////////////////////////////////////////////

    readonly property string procStat:
        "/proc/stat"

    readonly property string procMemInfo:
        "/proc/meminfo"

    readonly property string procUptime:
        "/proc/uptime"

}
