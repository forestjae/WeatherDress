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
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())

    private let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.3
        return view
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .systemFont(ofSize: 20, weight: .bold).metrics(for: .body)
        return label
    }()

    private let locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        return label
    }()

    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private let weatherImage = UIView()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .systemFont(ofSize: 27, weight: .medium).metrics(for: .body)
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
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        if indexPath == 0 {
            self.locationDescriptionLabel.isHidden = false
            self.locationDescriptionLabel.text = locationInfo.shortAddress()
            self.locationLabel.text = "나의 위치"
        } else {
            self.locationLabel.text = locationInfo.shortAddress()
        }
        self.listContentView.configuration = content

        self.temperatureLabel.text = weather.temperature.description + "°"
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.lightSky
        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.shadowColor = UIColor.black.cgColor
//        self.contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
//        self.contentView.layer.shadowRadius = 5
//        self.contentView.layer.masksToBounds = false
//        self.contentView.layer.shadowOpacity = 0.5
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.listContentView)
        self.listContentView.addSubview(self.containerView)
        self.containerView.addSubview(self.locationLabel)
        self.containerView.addSubview(self.temperatureLabel)
        self.containerView.addSubview(self.weatherImage)
        self.containerView.addSubview(self.locationDescriptionLabel)
        self.containerView.addSubview(self.weatherLabel)
    }

    private func configureConstraint() {
        self.listContentView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.contentView)
        }
        self.containerView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.listContentView)
        }
        self.locationLabel.snp.makeConstraints {
            $0.top.equalTo(self.containerView).offset(10)
            $0.leading.equalTo(self.containerView).offset(15)
        }
        self.locationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.locationLabel.snp.bottom)
            $0.leading.equalTo(self.locationLabel)
        }
        self.weatherLabel.snp.makeConstraints {
            $0.top.equalTo(self.locationLabel.snp.bottom).offset(-30)
            $0.leading.equalTo(self.locationLabel)
        }
//        self.weatherImage.snp.makeConstraints {
//            $0.width.height.equalTo(45)
//            $0.top.equalTo(self.containerView).offset(10)
//            $0.trailing.equalTo(self.containerView.snp.trailing).offset(-10)
//        }
        self.temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(self.weatherImage).offset(15)
            $0.trailing.equalTo(self.containerView.snp.trailing).offset(-10)
        }
    }
}
