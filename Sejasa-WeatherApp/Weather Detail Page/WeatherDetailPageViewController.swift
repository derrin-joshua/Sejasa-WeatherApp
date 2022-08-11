//
//  WeatherDetailPageViewController.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import CoreLocation
import UIKit

final class WeatherDetailPageViewController: UIViewController {
    private lazy var loadingView: LoadingView = {
        let loadingView: LoadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private lazy var gradientBackgroundLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.skyBlue.cgColor, UIColor.skyLightBlue.cgColor]
        gradientLayer.shouldRasterize = true
        return gradientLayer
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var weatherDetailStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 32.0
        return stackView
    }()
    
    private lazy var temperatureView: WeatherDetailItemView = {
        let weatherDetailItemView: WeatherDetailItemView = WeatherDetailItemView(title: "Temperature")
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        return weatherDetailItemView
    }()
    
    private lazy var windSpeedView: WeatherDetailItemView = {
        let weatherDetailItemView: WeatherDetailItemView = WeatherDetailItemView(title: "Wind Speed")
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        return weatherDetailItemView
    }()
    
    private lazy var humidityView: WeatherDetailItemView = {
        let weatherDetailItemView: WeatherDetailItemView = WeatherDetailItemView(title: "Humidity")
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        return weatherDetailItemView
    }()
    
    private lazy var changeUnitsTypeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        button.addTarget(self, action: #selector(changeUnitsTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToMapButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check Other Location", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(goToMapButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: WeatherDetailPageViewModelProtocol
    
    init(viewModel: WeatherDetailPageViewModelProtocol) {
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
        view.layer.addSublayer(gradientBackgroundLayer)
        
        weatherDetailStackView.addArrangedSubview(temperatureView)
        weatherDetailStackView.addArrangedSubview(windSpeedView)
        weatherDetailStackView.addArrangedSubview(humidityView)
        
        view.addSubviews([loadingView,
                          locationNameLabel,
                          weatherIconImageView,
                          weatherDescriptionLabel,
                          weatherDetailStackView,
                          changeUnitsTypeButton])
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            locationNameLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 2 * SpacingScheme.padding),
            locationNameLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: SpacingScheme.padding),
            locationNameLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -SpacingScheme.padding),

            weatherIconImageView.heightAnchor.constraint(equalToConstant: 152.0),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 152.0),
            weatherIconImageView.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: SpacingScheme.xl),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: SpacingScheme.m),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: SpacingScheme.padding),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -SpacingScheme.padding),
            
            weatherDetailStackView.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 2 * SpacingScheme.xl),
            weatherDetailStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeUnitsTypeButton.topAnchor.constraint(equalTo: weatherDetailStackView.bottomAnchor, constant: 2 * SpacingScheme.xl),
            changeUnitsTypeButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: SpacingScheme.padding),
            changeUnitsTypeButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -SpacingScheme.padding),
            changeUnitsTypeButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeBottomAnchor, constant: -SpacingScheme.padding).withPriority(UILayoutPriority(900))
        ])
        
        if !viewModel.isCustomLocationModal {
            view.addSubview(goToMapButton)
            NSLayoutConstraint.activate([
                goToMapButton.topAnchor.constraint(equalTo: changeUnitsTypeButton.bottomAnchor, constant: SpacingScheme.xs),
                goToMapButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: SpacingScheme.padding),
                goToMapButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -SpacingScheme.padding),
                goToMapButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeBottomAnchor, constant: -SpacingScheme.padding).withPriority(UILayoutPriority(1000))
            ])
        }
    }
    
    private func setupWeatherIconImage(weatherId: Int, timeCategory: TimeCategory) {
        var weatherIconImageName: String = ""
        if weatherId >= 200 && weatherId < 300 { // Thunderstorm
            weatherIconImageName = "cloud.bolt.rain.fill"
        }
        else if weatherId >= 300 && weatherId < 600 { // Rain
            weatherIconImageName = "cloud.rain.fill"
        }
        else if weatherId >= 600 && weatherId < 700 { // Snow
            weatherIconImageName = "snowflake"
        }
        else if weatherId >= 700 && weatherId < 800 { // Atmosphere
            weatherIconImageName = "cloud.fog.fill"
        }
        else if weatherId == 800 { // Clear
            weatherIconImageName = timeCategory == .evening ? "moon.fill" : "sun.max.fill"
        }
        else if weatherId >= 801 && weatherId < 900 { // Clouds
            weatherIconImageName = "cloud.fill"
        }
        weatherIconImageView.image = UIImage(systemName: weatherIconImageName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    private func setupBackgroundBasedOnTimeCategory(_ timeCategory: TimeCategory) {
        if timeCategory == .morning {
            gradientBackgroundLayer.colors = [UIColor.skyBlue.cgColor, UIColor.brightYellow.cgColor]
            goToMapButton.backgroundColor = .skyBlue
        }
        else if timeCategory == .noon {
            gradientBackgroundLayer.colors = [UIColor.skyBlue.cgColor, UIColor.skyLightBlue.cgColor]
            goToMapButton.backgroundColor = .systemBlue
        }
        else if timeCategory == .afternoon {
            gradientBackgroundLayer.colors = [UIColor.darkRedSky.cgColor, UIColor.orangeSky.cgColor]
            goToMapButton.backgroundColor = .darkRedSky
        }
        else if timeCategory == .evening {
            gradientBackgroundLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
            goToMapButton.backgroundColor = .systemGray2
        }
    }
    
    @objc
    private func changeUnitsTypeButtonTapped() {
        viewModel.onChangeUnitsTypeButtonTapped()
    }
    
    @objc
    private func goToMapButtonTapped() {
        viewModel.onGoToMapButtonTapped()
    }
}

extension WeatherDetailPageViewController: WeatherDetailPageViewModelAction {
    func showLoading(_ shouldShow: Bool) {
        if shouldShow { loadingView.show() }
        else { loadingView.hide() }
    }
    
    func showError() {
        loadingView.showError(refreshAction: {
            self.viewModel.onLoad()
        })
    }
    
    func displayWeatherInfo(_ weatherInfo: WeatherInfoResponse, unitsType: WeatherInfoFetcherUnitsType) {
        guard let weather: Weather = weatherInfo.weather else { return }
        locationNameLabel.text = weatherInfo.locationName
        weatherDescriptionLabel.text = weather.description.capitalized
        temperatureView.content = "\(weatherInfo.main.temp) \(unitsType == .metric ? "°C" : "°F")"
        windSpeedView.content = "\(weatherInfo.wind.speed) \(unitsType == .metric ? "mtr/s" : "mil/s")"
        humidityView.content = "\(weatherInfo.main.humidity)%"
        setupWeatherIconImage(weatherId: weather.id, timeCategory: weatherInfo.currentTimeCategory)
        setupBackgroundBasedOnTimeCategory(weatherInfo.currentTimeCategory)
        changeUnitsTypeButton.setTitle("Change to \(unitsType == .metric ? "Imperial" : "Metric") Units", for: .normal)
    }
    
    func navigateToMapPage(initialLocation: CLLocationCoordinate2D, unitsType: WeatherInfoFetcherUnitsType) {
        let mapPageVC: MapPageViewController = MapPageFactory.makeViewController(initialLocation: initialLocation, unitsType: unitsType)
        navigationController?.pushViewController(mapPageVC, animated: true)
    }
}
