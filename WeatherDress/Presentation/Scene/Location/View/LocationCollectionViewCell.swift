//
//  LocationCollectionViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/01.
//

import Foundation
import UIKit

private enum Design {
    static let mainFontColor: UIColor = .white
}

class LocationCollectionViewCell: UICollectionViewCell {
    private let listContentView: UIListContentView = {
        let listContentView = UIListContentView(configuration: .subtitleCell())
        listContentView.layer.shadowColor = UIColor.black.cgColor
        listContentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        listContentView.layer.shadowRadius = 2
        listContentView.layer.masksToBounds = false
        listContentView.layer.shadowOpacity = 0.3
        return listContentView
    }()

    private let locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        return label
    }()

    private let weatherImage = UIImageView()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .systemFont(ofSize: 30, weight: .regular).metrics(for: .body)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension LocationCollectionViewCell {
    func configure(with locationInfo: LocationInfo, indexPath: Int, weather: CurrentWeather) {
        var content = UIListContentConfiguration.cell()

        if indexPath == 0 {
            content.text = "나의 위치"
            self.locationDescriptionLabel.isHidden = false
            self.locationDescriptionLabel.text = locationInfo.shortAddress()
        } else {
            content.text = locationInfo.shortAddress()
        }
        content.textProperties.font = .systemFont(ofSize: 20, weight: .bold).metrics(for: .body)
        content.textProperties.color = Design.mainFontColor
        content.secondaryText = weather.weatherCondition.rawValue
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.color = Design.mainFontColor
        content.textToSecondaryTextVerticalPadding = 35

        self.listContentView.configuration = content

        self.weatherImage.image = UIImage(named: weather.weatherCondition.staticImageURL)
        self.temperatureLabel.text = Int(weather.temperature).description + "°"
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.lightSky
        self.contentView.layer.cornerRadius = 10
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.listContentView)
        self.listContentView.addSubview(self.temperatureLabel)
        self.listContentView.addSubview(self.weatherImage)
        self.listContentView.addSubview(self.locationDescriptionLabel)
    }

    private func configureConstraint() {
        self.listContentView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.contentView)
        }
        self.locationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.listContentView).offset(32)
            $0.leading.equalTo(self.listContentView).offset(16)
        }
        self.temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(self.listContentView).offset(15)
            $0.trailing.equalTo(self.listContentView).offset(-20)
        }
        self.weatherImage.snp.makeConstraints {
            $0.width.height.equalTo(45)
            $0.top.equalTo(self.temperatureLabel.snp.bottom).offset(2)
            $0.trailing.equalTo(self.listContentView).offset(-20)
        }
    }
}
