//
//  WeatherInfoResponse.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import Foundation

enum TimeCategory {
    case morning, noon, afternoon, evening
}

struct WeatherInfoResponse: Codable, Equatable {
    let coord: WeatherCoordinate
    let weathers: [Weather]
    let main: WeatherMain
    let wind: WeatherWind
    let locationName: String
    let timezone: Int
    
    private enum CodingKeys: String, CodingKey {
        case coord, weathers = "weather", main, wind, locationName = "name", timezone
    }
    
    var weather: Weather? {
        get {
            return weathers.first
        }
    }
    
    var currentTimeCategory: TimeCategory {
        get {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
            dateFormatter.dateFormat = "HH"
            
            let hourString: String = dateFormatter.string(from: Date())
            let hourInt: Int = Int(hourString) ?? 11
            
            if hourInt >= 6 && hourInt < 11 {
                return .morning
            }
            else if hourInt >= 11 && hourInt < 4 {
                return .noon
            }
            else if hourInt >= 4 && hourInt < 7 {
                return .afternoon
            }
            else {
                return .evening
            }
        }
    }
    
    static func == (lhs: WeatherInfoResponse, rhs: WeatherInfoResponse) -> Bool {
        return lhs.coord == rhs.coord && lhs.weather == rhs.weather && lhs.main == rhs.main && lhs.wind == rhs.wind && lhs.locationName == rhs.locationName && lhs.timezone == rhs.timezone
    }
}

struct WeatherCoordinate: Codable, Equatable {
    let lat: Double
    let lon: Double
    
    static func == (lhs: WeatherCoordinate, rhs: WeatherCoordinate) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
}

struct Weather: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id && lhs.main == rhs.main && lhs.description == rhs.description && lhs.icon == rhs.icon
    }
}

struct WeatherMain: Codable, Equatable {
    let temp: Double
    let humidity: Double
    
    static func == (lhs: WeatherMain, rhs: WeatherMain) -> Bool {
        return lhs.temp == rhs.temp && lhs.humidity == rhs.humidity
    }
}

struct WeatherWind: Codable, Equatable {
    let speed: Double
    
    static func == (lhs: WeatherWind, rhs: WeatherWind) -> Bool {
        return lhs.speed == rhs.speed
    }
}
