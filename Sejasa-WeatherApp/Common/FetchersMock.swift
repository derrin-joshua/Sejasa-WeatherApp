//
//  FetchersMock.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 11/08/22.
//

import Foundation

final class WeatherInfoFetcherMock: WeatherInfoFetcherProtocol {
    var lat: Double?
    var lon: Double?
    var unitsType: WeatherInfoFetcherUnitsType?
    var fetched: ((@escaping (WeatherInfoResponse) -> Void, @escaping (Error?) -> Void) -> Void)?
    
    func fetch(lat: Double,
               lon: Double,
               unitsType: WeatherInfoFetcherUnitsType,
               onSuccess: @escaping (WeatherInfoResponse) -> Void,
               onFailure: @escaping (Error?) -> Void) {
        self.lat = lat
        self.lon = lon
        self.unitsType = unitsType
        fetched?(onSuccess, onFailure)
    }
}
