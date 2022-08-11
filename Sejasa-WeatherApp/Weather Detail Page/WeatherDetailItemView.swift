//
//  WeatherDetailItemView.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import UIKit

final class WeatherDetailItemView: UIView {
    // MARK: - Internal Properties
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var content: String? {
        get {
            return contentLabel.text
        }
        set {
            contentLabel.text = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String? = nil, content: String? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.content = content
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews([titleLabel, contentLabel])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeTopAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor),

            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SpacingScheme.xxs),
            contentLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor)
        ])
    }
}
