//
//  DailyWeatherTableViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import UIKit

class DailyWeaterTableViewCell: UITableViewCell {

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

    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with weather: DailyWeather, indexPath: Int) {
        self.timeLabel.text = DateFormatter.DailyWeatherDate.string(from: weather.date)
        self.minTemperatureLabel.text = weather.minimunTemperature.description
        self.maxTemperatureLabel.text = weather.maximumTemperature.description
        self.skyConditionImageView.image = UIImage(named: weather.weatherCondition.staticImageURL)
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.skyConditionImageView)
        self.contentView.addSubview(self.maxTemperatureLabel)
        self.contentView.addSubview(self.minTemperatureLabel)
    }

    private func configureConstraint() {
        self.timeLabel.snp.makeConstraints {
            $0.leading.centerY.equalTo(self.contentView)
        }

        self.skyConditionImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalTo(self.timeLabel.snp.trailing)
            $0.centerY.equalTo(self.contentView)
        }
        self.minTemperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(self.skyConditionImageView.snp.trailing)
            $0.centerY.equalTo(self.contentView)
        }
        self.maxTemperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(self.minTemperatureLabel.snp.trailing)
            $0.centerY.equalTo(self.contentView)
        }
    }
}
