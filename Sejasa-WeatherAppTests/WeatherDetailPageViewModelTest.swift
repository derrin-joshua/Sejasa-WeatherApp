//
//  WeatherDetailPageViewModelTest.swift
//  Sejasa-WeatherAppTests
//
//  Created by Derrin on 11/08/22.
//

import Nimble
import Quick
@testable import Sejasa_WeatherApp
import CoreLocation
import UIKit

final class WeatherDetailPageViewModelTest: QuickSpec {
    override func spec() {
        describe("WeatherDetailPageViewModelTest") {
            var weatherInfoFetcher: WeatherInfoFetcherMock!
            var viewModel: WeatherDetailPageViewModel!
            var action: ActionMock!
            
            let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
            
            beforeEach {
                weatherInfoFetcher = WeatherInfoFetcherMock()
                viewModel = WeatherDetailPageViewModel(weatherInfoFetcher: weatherInfoFetcher, currentLocation: currentLocation, isCustomLocationModal: false)
                action = ActionMock()
                viewModel.action = action
            }
            
            context("onLoad") {
                it("show loading, fetch success, hide loading") {
                    let dummyWeatherInfoResponse: WeatherInfoResponse = UnitTestHelper.makeWeatherInfoResponse(location: currentLocation)
                    weatherInfoFetcher.fetched = { onSuccess, _ in
                        onSuccess(dummyWeatherInfoResponse)
                    }
                    
                    viewModel.onLoad()
                    
                    expect(action.loadingVisibilityStates.count) == 1
                    expect(action.loadingVisibilityStates[0]) == true
                    
                    expect(weatherInfoFetcher.lat) == currentLocation.latitude
                    expect(weatherInfoFetcher.lon) == currentLocation.longitude
                    expect(weatherInfoFetcher.unitsType) == .metric
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        expect(action.displayedWeatherInfo) == dummyWeatherInfoResponse
                        expect(action.displayedWeatherInfoUnitsType) == .metric
                        
                        expect(action.loadingVisibilityStates.count) == 2
                        expect(action.loadingVisibilityStates[1]) == false
                    }
                }
                
                it("fetch error") {
                    weatherInfoFetcher.fetched = { _, onError in
                        onError(nil)
                    }
                    
                    viewModel.onLoad()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        expect(action.isErrorShowing) == true
                    }
                }
            }
            
            context("onChangeUnitsTypeButtonTapped") {
                it("change units type, fetch weather info") {
                    let dummyWeatherInfoResponse: WeatherInfoResponse = UnitTestHelper.makeWeatherInfoResponse(location: currentLocation)
                    weatherInfoFetcher.fetched = { onSuccess, _ in
                        onSuccess(dummyWeatherInfoResponse)
                    }
                    
                    viewModel.onChangeUnitsTypeButtonTapped()
                    
                    expect(weatherInfoFetcher.lat) == currentLocation.latitude
                    expect(weatherInfoFetcher.lon) == currentLocation.longitude
                    expect(weatherInfoFetcher.unitsType) == .imperial
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        expect(action.displayedWeatherInfo) == dummyWeatherInfoResponse
                        expect(action.displayedWeatherInfoUnitsType) == .imperial
                    }
                }
            }
            
            context("onGoToMapButtonTapped") {
                it("navigate to map") {
                    viewModel.onGoToMapButtonTapped()
                    
                    expect(action.mapInitialLocation?.latitude) == currentLocation.latitude
                    expect(action.mapInitialLocation?.longitude) == currentLocation.longitude
                    expect(action.mapUnitsType) == .metric
                }
            }
        }
    }
}

private final class ActionMock: WeatherDetailPageViewModelAction {
    var loadingVisibilityStates: [Bool] = []
    func showLoading(_ shouldShow: Bool) {
        loadingVisibilityStates.append(shouldShow)
    }
    
    var isErrorShowing: Bool = false
    func showError() {
        isErrorShowing = true
    }
    
    var displayedWeatherInfo: WeatherInfoResponse?
    var displayedWeatherInfoUnitsType: WeatherInfoFetcherUnitsType?
    func displayWeatherInfo(_ weatherInfo: WeatherInfoResponse, unitsType: WeatherInfoFetcherUnitsType) {
        displayedWeatherInfo = weatherInfo
        displayedWeatherInfoUnitsType = unitsType
    }
    
    var mapInitialLocation: CLLocationCoordinate2D?
    var mapUnitsType: WeatherInfoFetcherUnitsType?
    func navigateToMapPage(initialLocation: CLLocationCoordinate2D, unitsType: WeatherInfoFetcherUnitsType) {
        mapInitialLocation = initialLocation
        mapUnitsType = unitsType
    }
    
    
}
