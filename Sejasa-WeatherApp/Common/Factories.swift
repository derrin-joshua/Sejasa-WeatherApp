//
//  Factories.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import CoreLocation
import Foundation

struct WeatherDetailPageFactory {
    static func makeViewController(currentLocation: CLLocationCoordinate2D? = nil, isCustomLocationModal: Bool = false) -> WeatherDetailPageViewController {
        let viewModel: WeatherDetailPageViewModel = WeatherDetailPageViewModel(weatherInfoFetcher: WeatherInfoFetcher(), currentLocation: currentLocation, isCustomLocationModal: isCustomLocationModal)
        let viewController: WeatherDetailPageViewController = WeatherDetailPageViewController(viewModel: viewModel)
        viewModel.action = viewController
        return viewController
    }
}

struct MapPageFactory {
    static func makeViewController(initialLocation: CLLocationCoordinate2D, unitsType: WeatherInfoFetcherUnitsType) -> MapPageViewController {
        let viewModel: MapPageViewModel = MapPageViewModel(weatherInfoFetcher: WeatherInfoFetcher(), initialLocation: initialLocation, unitsType: unitsType)
        let viewController: MapPageViewController = MapPageViewController(viewModel: viewModel)
        viewModel.action = viewController
        return viewController
    }
}
