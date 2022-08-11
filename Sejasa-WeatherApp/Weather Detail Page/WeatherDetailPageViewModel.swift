//
//  WeatherDetailPageViewModel.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import CoreLocation
import Foundation

protocol WeatherDetailPageViewModelProtocol: AnyObject {
    var isCustomLocationModal: Bool { get }
    var action: WeatherDetailPageViewModelAction? { get set }
    
    func onLoad()
    func onChangeUnitsTypeButtonTapped()
    func onGoToMapButtonTapped()
}

protocol WeatherDetailPageViewModelAction: AnyObject {
    func showLoading(_ shouldShow: Bool)
    func showError()
    func displayWeatherInfo(_ weatherInfo: WeatherInfoResponse, unitsType: WeatherInfoFetcherUnitsType)
    func navigateToMapPage(initialLocation: CLLocationCoordinate2D, unitsType: WeatherInfoFetcherUnitsType)
}

final class WeatherDetailPageViewModel: NSObject {
    let isCustomLocationModal: Bool // If true, should not get user location & should not show go to map button
    weak var action: WeatherDetailPageViewModelAction?
    
    private let weatherInfoFetcher: WeatherInfoFetcherProtocol
    private var unitsType: WeatherInfoFetcherUnitsType = .metric
    private let locationManager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
    
    init(weatherInfoFetcher: WeatherInfoFetcherProtocol, currentLocation: CLLocationCoordinate2D? = nil, isCustomLocationModal: Bool) {
        self.weatherInfoFetcher = weatherInfoFetcher
        if let currentLocation: CLLocationCoordinate2D = currentLocation {
            self.currentLocation = currentLocation
        }
        self.isCustomLocationModal = isCustomLocationModal
        super.init()
    }
    
    private func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func fetchWeatherInfoInCurrentLocation() {
        weatherInfoFetcher.fetch(lat: currentLocation.latitude,
                                 lon: currentLocation.longitude,
                                 unitsType: unitsType,
                                 onSuccess: { [weak self] weatherInfoResponse in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.action?.displayWeatherInfo(weatherInfoResponse, unitsType: self.unitsType)
                self.action?.showLoading(false)
            }
        }, onFailure: { _ in
            self.action?.showError()
        })
    }
}

// MARK: - WeatherDetailPageViewModelProtocol
extension WeatherDetailPageViewModel: WeatherDetailPageViewModelProtocol {
    func onLoad() {
        action?.showLoading(true)
        fetchWeatherInfoInCurrentLocation()
        if !isCustomLocationModal { getUserLocation() }
    }
    
    func onChangeUnitsTypeButtonTapped() {
        unitsType = unitsType == .metric ? .imperial : .metric
        fetchWeatherInfoInCurrentLocation()
    }
    
    func onGoToMapButtonTapped() {
        action?.navigateToMapPage(initialLocation: currentLocation, unitsType: unitsType)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherDetailPageViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        if location.coordinate.latitude != currentLocation.latitude,
           location.coordinate.longitude != currentLocation.longitude {
            currentLocation = location.coordinate
            fetchWeatherInfoInCurrentLocation()
        }
    }
}
