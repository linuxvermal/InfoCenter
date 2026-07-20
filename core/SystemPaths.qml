pragma Singleton

import QtQuick

QtObject {

    ////////////////////////////////////////////////////////
    // Hardware Monitor Paths
    ////////////////////////////////////////////////////////

    // CPU temperature
    readonly property string cpuTemp:
        "/sys/class/hwmon/hwmon2/temp1_input"

    // GPU temperature
    readonly property string gpuTemp:
        "/sys/class/hwmon/hwmon1/temp1_input"

    // SSD / NVMe temperature
    readonly property string ssdTemp:
        "/sys/class/hwmon/hwmon0/temp1_input"

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
