//
//  MapPageViewModelTest.swift
//  Sejasa-WeatherAppTests
//
//  Created by Derrin on 10/08/22.
//

import CoreLocation
import Nimble
import Quick
import UIKit
@testable import Sejasa_WeatherApp

final class MapPageViewModelTest: QuickSpec {
    override func spec() {
        var weatherInfoFetcher: WeatherInfoFetcherMock!
        var viewModel: MapPageViewModel!
        var action: ActionMock!
        
        let unitsType: WeatherInfoFetcherUnitsType = .metric
        let initialLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
        
        describe("MapPageViewModelTest") {
            beforeEach {
                weatherInfoFetcher = WeatherInfoFetcherMock()
                viewModel = MapPageViewModel(weatherInfoFetcher: weatherInfoFetcher, initialLocation: initialLocation, unitsType: unitsType)
                action = ActionMock()
                viewModel.action = action
            }
            
            context("onLoad") {
                it("set the map initial lcoation") {
                    viewModel.onLoad()
                    
                    expect(action.setMapInitialLocation?.latitude) == initialLocation.latitude
                    expect(action.setMapInitialLocation?.longitude) == initialLocation.longitude
                }
            }
            
            context("onMapViewTapped") {
                it("fetch weather info and add annotation") {
                    let dummyWeatherInfoResponse: WeatherInfoResponse = UnitTestHelper.makeWeatherInfoResponse(location: initialLocation)
                    weatherInfoFetcher.fetched = { onSuccess, _ in
                        onSuccess(dummyWeatherInfoResponse)
                    }
                    
                    viewModel.onMapViewTapped(location: initialLocation)
                    
                    expect(weatherInfoFetcher.lat) == initialLocation.latitude
                    expect(weatherInfoFetcher.lon) == initialLocation.longitude
                    expect(weatherInfoFetcher.unitsType) == unitsType
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        expect(action.selectedLocationWeatherAdded?.coordinate.latitude) == initialLocation.latitude
                        expect(action.selectedLocationWeatherAdded?.coordinate.longitude) == initialLocation.longitude
                        expect(action.selectedLocationWeatherAdded?.weatherInfo) == dummyWeatherInfoResponse
                    }
                }
            }
            
            context("onMapAnnotationDetailTapped") {
                it("open weather detail modal") {
                    let dummyWeatherInfoResponse: WeatherInfoResponse = UnitTestHelper.makeWeatherInfoResponse(location: initialLocation)
                    let dummySelectedLocationWeather: MapSelectedLocationWeather = MapSelectedLocationWeather(coordinate: initialLocation, weatherInfo: dummyWeatherInfoResponse)
                    viewModel.onMapAnnotationDetailTapped(selectedLocationWeather: dummySelectedLocationWeather)
                    
                    expect(action.locationOpened?.latitude) == initialLocation.latitude
                    expect(action.locationOpened?.longitude) == initialLocation.longitude
                }
            }
        }
    }
}

private final class ActionMock: MapPageViewModelAction {
    var setMapInitialLocation: CLLocationCoordinate2D?
    func setMapInitialLocation(_ initialLocation: CLLocationCoordinate2D) {
        setMapInitialLocation = initialLocation
    }
    
    var selectedLocationWeatherAdded: MapSelectedLocationWeather?
    func addSelectedLocationWeatherAnnotation(_ selectedLocationWeather: MapSelectedLocationWeather) {
        selectedLocationWeatherAdded = selectedLocationWeather
    }
    
    var locationOpened: CLLocationCoordinate2D?
    func openSelectedLocationWeatherDetailModal(location: CLLocationCoordinate2D) {
        locationOpened = location
    }
}
