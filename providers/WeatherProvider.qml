/******************************************************************************
 * WeatherProvider
 *
 * Automatically determines the user's approximate location using a public
 * IP geolocation service, then retrieves current weather conditions from
 * Open-Meteo.
 *
 * Location:
 *   Primary: ipapi.co
 *   Backup : ipinfo.io
 *
 * Weather:
 *   Open-Meteo
 ******************************************************************************/


import QtQuick

Item {

    id: root

    visible: false

    width: 0
    height: 0

    property double latitude: 34.1064
    property double longitude: -117.3703

    property double lastLocationUpdate: 0

    property bool available: false
    property string icon: "☁"
    property int temperature: 0
    property string temperatureText: temperature + "°F"
    property string condition: "Loading..."

    function weatherIcon(code) {
        switch (code) {
        case 0: return "☀"
        case 1: return "🌤"
        case 2: return "⛅"
        case 3: return "☁"
        case 45:
        case 48: return "🌫"
        }

        if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82))
            return "🌧"

        if (code >= 71 && code <= 77)
            return "🌨"

        if (code >= 95)
            return "⛈"

        return "☁"
    }

    function weatherDescription(code) {
        switch (code) {
        case 0: return "Clear Sky"
        case 1: return "Mostly Clear"
        case 2: return "Partly Cloudy"
        case 3: return "Overcast"
        case 45:
        case 48: return "Fog"
        }

        if (code >= 51 && code <= 55)
            return "Light Drizzle"

        if (code >= 56 && code <= 57)
            return "Freezing Drizzle"

        if (code >= 61 && code <= 63)
            return "Light Rain"

        if (code >= 65 && code <= 67)
            return "Heavy Rain"

        if (code >= 71 && code <= 73)
            return "Light Snow"

        if (code >= 75 && code <= 77)
            return "Heavy Snow"

        if (code >= 80 && code <= 82)
            return "Rain Showers"

        if (code >= 85 && code <= 86)
            return "Snow Showers"

        if (code >= 95)
            return "Thunderstorm"

    }

    function refresh() {

    var now = Date.now()

    //
    // Update location once per hour.
    //

    if (now - lastLocationUpdate >= 60 * 60 * 1000) {

        updateLocation()
        return

    }

    //
    // Otherwise just refresh the weather.
    //

    updateWeather()

    }

    function updateLocation() {

    updateLocationPrimary()

}

function updateLocationPrimary() {

    var xhr = new XMLHttpRequest()

    xhr.onreadystatechange = function() {

        if (xhr.readyState !== XMLHttpRequest.DONE)
            return

        if (xhr.status !== 200) {
            updateLocationBackup()
            return
        }

        try {
            var data = JSON.parse(xhr.responseText)

            latitude = data.latitude
            longitude = data.longitude

            lastLocationUpdate = Date.now()

            updateWeather()

        } catch(e) {
            updateLocationBackup()
        }
    }

    xhr.open("GET", "https://ipapi.co/json/")
    xhr.send()
}

function updateLocationBackup() {

    var xhr = new XMLHttpRequest()

    xhr.onreadystatechange = function() {

        if (xhr.readyState !== XMLHttpRequest.DONE)
            return

        if (xhr.status !== 200) {
            updateWeather()
            return
        }

        try {
            var data = JSON.parse(xhr.responseText)
            var loc = data.loc.split(",")

            latitude = parseFloat(loc[0])
            longitude = parseFloat(loc[1])

        } catch(e) {
            // Continue using cached coordinates
        }

        updateWeather()
    }

    xhr.open("GET", "https://ipinfo.io/json")
    xhr.send()
}

function updateWeather() {
        var xhr = new XMLHttpRequest()

        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return

            if (xhr.status !== 200) {
                available = false
                condition = "Offline"
                return
            }

            try {
                var data = JSON.parse(xhr.responseText)

                temperature = Math.round(data.current.temperature_2m)
                icon = weatherIcon(data.current.weather_code)
                condition = weatherDescription(data.current.weather_code)
                available = true

            } catch (e) {
                available = false
                condition = "Offline"
            }
        }

        xhr.open(
            "GET",
            "https://api.open-meteo.com/v1/forecast?latitude="
            + latitude
            + "&longitude="
            + longitude
            + "&current=temperature_2m,weather_code&temperature_unit=fahrenheit"
        )

        xhr.send()
    }

    Timer {
        interval: 15 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
