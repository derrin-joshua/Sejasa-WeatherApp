//
//  Fetchers.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import Foundation

typealias JSONObject = [String : Any]

enum WeatherInfoFetcherUnitsType: String {
    case metric = "metric"
    case imperial = "imperial"
}

protocol WeatherInfoFetcherProtocol {
    func fetch(lat: Double,
               lon: Double,
               unitsType: WeatherInfoFetcherUnitsType,
               onSuccess: @escaping (WeatherInfoResponse) -> Void,
               onFailure: @escaping (Error?) -> Void)
}

struct WeatherInfoFetcher: WeatherInfoFetcherProtocol {
    func fetch(lat: Double,
               lon: Double,
               unitsType: WeatherInfoFetcherUnitsType = .metric,
               onSuccess: @escaping (WeatherInfoResponse) -> Void,
               onFailure: @escaping (Error?) -> Void) {
        let appId: String = "fdf871cedaf3413c6a23230372c30a02"
        let urlString: String = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appId)&units=\(unitsType)"
        guard let url: URL = URL(string: urlString) else { return }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data: Data = data,
                  let weatherInfoResponseJSON: JSONObject = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject,
                  let weatherInfoResponseData: Data = try? JSONSerialization.data(withJSONObject: weatherInfoResponseJSON, options: []),
                  let weatherInfoResponse: WeatherInfoResponse = try? JSONDecoder().decode(WeatherInfoResponse.self, from: weatherInfoResponseData) else {
                onFailure(error)
                return
            }
            onSuccess(weatherInfoResponse)
        })
        task.resume()
    }
}
