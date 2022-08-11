//
//  UnitTestHelper.swift
//  Sejasa-WeatherAppTests
//
//  Created by Derrin on 11/08/22.
//

import CoreLocation
@testable import Sejasa_WeatherApp

struct UnitTestHelper {
    static func makeWeatherInfoResponse(location: CLLocationCoordinate2D) -> WeatherInfoResponse {
        let coord: WeatherCoordinate = WeatherCoordinate(lat: location.latitude, lon: location.longitude)
        let weather: Weather = Weather(id: 123, main: "weather_main", description: "weather_desc", icon: "weather_icon")
        let main: WeatherMain = WeatherMain(temp: 10.0, humidity: 20.0)
        let wind: WeatherWind = WeatherWind(speed: 30.0)
        return WeatherInfoResponse(coord: coord, weathers: [weather], main: main, wind: wind, locationName: "weather_location_name", timezone: 321)
    }
}
