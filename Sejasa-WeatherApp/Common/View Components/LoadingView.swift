//
//  LoadingView.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 10/08/22.
//

import UIKit

final class LoadingView: UIView {
    // MARK: - Internal Properties
    
    var refreshAction: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .skyBlue
        return activityIndicatorView
    }()
    
    private lazy var errorContainer: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0)
        label.text = "Oops! We couldn't load the page.\nPlease try to refresh."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Refresh Page", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        button.backgroundColor = .skyBlue
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func show() {
        DispatchQueue.main.async {
            guard let superview: UIView = self.superview else { return }
            superview.bringSubviewToFront(self)
            self.isHidden = false
            
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            
            self.errorContainer.isHidden = true
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            guard let superview: UIView = self.superview else { return }
            superview.sendSubviewToBack(self)
            self.isHidden = true
            
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
            
            self.errorContainer.isHidden = true
        }
    }
    
    func showError(refreshAction: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            guard let superview: UIView = self.superview else { return }
            superview.bringSubviewToFront(self)
            self.isHidden = false
        
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        
            self.errorContainer.isHidden = false
            self.refreshAction = refreshAction
        }
    }
    
    // MARK: - Internal Methods
    
    private func setupView() {
        backgroundColor = UIColor.white
        
        errorContainer.addSubviews([errorMessageLabel, refreshButton])
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: errorContainer.topAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: SpacingScheme.m),
            errorMessageLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -SpacingScheme.m),
            
            refreshButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: SpacingScheme.xl),
            refreshButton.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: SpacingScheme.l),
            refreshButton.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -SpacingScheme.l),
            refreshButton.bottomAnchor.constraint(equalTo: errorContainer.bottomAnchor)
        ])
        
        addSubviews([loadingIndicator, errorContainer])
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc
    private func refreshButtonTapped() {
        guard let refreshAction: () -> Void = refreshAction else { return }
        refreshAction()
    }
}
