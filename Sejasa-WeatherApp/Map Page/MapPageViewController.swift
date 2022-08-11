//
//  MapPageViewController.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 10/08/22.
//

import MapKit
import UIKit

final class MapPageViewController: UIViewController {
    private lazy var mapView: MKMapView = {
        let mapView: MKMapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(sender:))))
        return mapView
    }()
    
    private let viewModel: MapPageViewModelProtocol
    
    init(viewModel: MapPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.onLoad()
    }
    
    private func setupView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func mapViewTapped(sender: UITapGestureRecognizer) {
        let touchLocation: CGPoint = sender.location(in: mapView)
        let locationCoordinate: CLLocationCoordinate2D = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        viewModel.onMapViewTapped(location: locationCoordinate)
    }
}

extension MapPageViewController: MapPageViewModelAction {
    func setMapInitialLocation(_ initialLocation: CLLocationCoordinate2D) {
        let coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addSelectedLocationWeatherAnnotation(_ selectedLocationWeather: MapSelectedLocationWeather) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(selectedLocationWeather)
        mapView.selectAnnotation(selectedLocationWeather, animated: true)
    }
    
    func openSelectedLocationWeatherDetailModal(location: CLLocationCoordinate2D) {
        let weatherDetailPageVC: WeatherDetailPageViewController = WeatherDetailPageFactory.makeViewController(currentLocation: location, isCustomLocationModal: true)
        navigationController?.present(weatherDetailPageVC, animated: true)
    }
}

extension MapPageViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let selectedLocationWeather: MapSelectedLocationWeather = annotation as? MapSelectedLocationWeather else { return nil }
        
        let identifier: String = "MapSelectedLocationWeather"
        var annotationView: MKMarkerAnnotationView
        if let dequeuedView: MKMarkerAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = selectedLocationWeather
            annotationView = dequeuedView
        }
        else {
            annotationView = MKMarkerAnnotationView(annotation: selectedLocationWeather, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let selectedLocationWeather: MapSelectedLocationWeather = view.annotation as? MapSelectedLocationWeather else { return }
        viewModel.onMapAnnotationDetailTapped(selectedLocationWeather: selectedLocationWeather)
    }
}
