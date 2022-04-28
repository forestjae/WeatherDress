//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import UIKit
import SnapKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        let custom = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: custom)
        return label
    }()

    private let skyConditionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with weather: HourlyWeather, indexPath: Int) {
        if indexPath == 0 {
            self.timeLabel.text = "지금"
        } else {
            self.timeLabel.text = DateFormatter.hourlyWeatherTime.string(from: weather.date)
        }
        self.temperatureLabel.text = weather.temperature.description + "°"
        self.skyConditionImageView.image = UIImage(named: weather.weatherCondition.staticImageURL)
    }

    private func configureCell() {

    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.timeLabel)
        self.stackView.addArrangedSubview(self.skyConditionImageView)
        self.stackView.addArrangedSubview(self.temperatureLabel)
    }

    private func configureConstraint() {
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.contentView)
        }
        self.skyConditionImageView.snp.makeConstraints {

            $0.width.equalTo(self.skyConditionImageView.snp.height)
        }
    }
}
