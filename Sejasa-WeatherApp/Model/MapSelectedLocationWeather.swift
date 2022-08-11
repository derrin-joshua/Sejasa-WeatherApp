//
//  MapSelectedLocationWeather.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 10/08/22.
//

import MapKit

class MapSelectedLocationWeather: NSObject, MKAnnotation {
    var title: String? {
        return weatherInfo.weather?.description.capitalized
    }
    
    var subtitle: String? {
        let lat: String = String(format: "%.3f", coordinate.latitude)
        let lon: String = String(format: "%.3f", coordinate.longitude)
        return "Lat: \(lat) | Lon: \(lon)"
    }
    
    let coordinate: CLLocationCoordinate2D
    let weatherInfo: WeatherInfoResponse

    init(coordinate: CLLocationCoordinate2D, weatherInfo: WeatherInfoResponse) {
        self.coordinate = coordinate
        self.weatherInfo = weatherInfo
        super.init()
    }
}
