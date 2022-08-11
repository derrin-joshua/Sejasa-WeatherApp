//
//  MapPageViewModel.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 10/08/22.
//

import CoreLocation
import Foundation

protocol MapPageViewModelProtocol: AnyObject {
    var action: MapPageViewModelAction? { get set }
    
    func onLoad()
    func onMapViewTapped(location: CLLocationCoordinate2D)
    func onMapAnnotationDetailTapped(selectedLocationWeather: MapSelectedLocationWeather)
}

protocol MapPageViewModelAction: AnyObject {
    func setMapInitialLocation(_ initialLocation: CLLocationCoordinate2D)
    func addSelectedLocationWeatherAnnotation(_ selectedLocationWeather: MapSelectedLocationWeather)
    func openSelectedLocationWeatherDetailModal(location: CLLocationCoordinate2D)
}

final class MapPageViewModel {
    weak var action: MapPageViewModelAction?
    
    private let weatherInfoFetcher: WeatherInfoFetcherProtocol
    private let initialLocation: CLLocationCoordinate2D
    private let unitsType: WeatherInfoFetcherUnitsType
    private var selectedLocationWeather: MapSelectedLocationWeather? {
        didSet {
            guard let selectedLocationWeather: MapSelectedLocationWeather = selectedLocationWeather else { return }
            DispatchQueue.main.async {
                self.action?.addSelectedLocationWeatherAnnotation(selectedLocationWeather)
            }
        }
    }
    
    init(weatherInfoFetcher: WeatherInfoFetcherProtocol, initialLocation: CLLocationCoordinate2D, unitsType: WeatherInfoFetcherUnitsType) {
        self.weatherInfoFetcher = weatherInfoFetcher
        self.initialLocation = initialLocation
        self.unitsType = unitsType
    }
}

extension MapPageViewModel: MapPageViewModelProtocol {
    func onLoad() {
        action?.setMapInitialLocation(initialLocation)
    }
    
    func onMapViewTapped(location: CLLocationCoordinate2D) {
        weatherInfoFetcher.fetch(lat: location.latitude,
                                 lon: location.longitude,
                                 unitsType: unitsType,
                                 onSuccess: { [weak self] weatherInfoResponse in
            guard let self = self else { return }
            self.selectedLocationWeather = MapSelectedLocationWeather(coordinate: location, weatherInfo: weatherInfoResponse)
        }, onFailure: { _ in
            print("Failed fetching weather info.")
        })
    }
    
    func onMapAnnotationDetailTapped(selectedLocationWeather: MapSelectedLocationWeather) {
        action?.openSelectedLocationWeatherDetailModal(location: selectedLocationWeather.coordinate)
    }
}
