//
//  DailyWeatherCollectionViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/29.
//

import Foundation
import UIKit

private enum Design {
    static let mainFontColor: UIColor = .white
}

class DailyWeaterCollectionViewCell: UICollectionViewCell {

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        let custom = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: custom)
        return label
    }()

    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        let custom = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: custom)
        return label
    }()

    private let skyConditionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cold
        label.font = .systemFont(ofSize: 17, weight: .medium).metrics(for: .body)
        return label
    }()

    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .systemFont(ofSize: 17, weight: .medium).metrics(for: .body)
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
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

    func configureContent(with weather: DailyWeather, indexPath: Int) {
        self.dayOfWeekLabel.text = DateFormatter.dayOfWeekDate.string(from: weather.date)
        if indexPath == 0 {
            self.timeLabel.text = "오늘"
        } else if indexPath == 1 {
            self.timeLabel.text = "내일"
        } else if indexPath == 2 {
            self.timeLabel.text = "모레"
        } else {
            self.timeLabel.text = DateFormatter.dailyWeatherDate.string(from: weather.date)
        }
        if indexPath == 10 {
            self.separatorView.isHidden = true
        }
        self.minTemperatureLabel.text = weather.minimunTemperature.description + "°"
        self.maxTemperatureLabel.text = weather.maximumTemperature.description + "°"
        self.skyConditionImageView.image = UIImage(named: weather.weatherCondition.staticImageURL)
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.dayOfWeekLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.skyConditionImageView)
        self.contentView.addSubview(self.maxTemperatureLabel)
        self.contentView.addSubview(self.minTemperatureLabel)
        self.contentView.addSubview(self.separatorView)
    }

    private func configureConstraint() {
        self.dayOfWeekLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView).offset(20)
        }
        self.timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.dayOfWeekLabel)
            $0.leading.equalTo(self.dayOfWeekLabel.snp.trailing).offset(2)
        }

        self.skyConditionImageView.snp.makeConstraints {
            $0.width.height.equalTo(33)
            $0.leading.equalTo(self.contentView.snp.leading).offset(150)
            $0.centerY.equalTo(self.contentView)
        }

        self.minTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-60)
            $0.centerY.equalTo(self.contentView)
        }
        self.maxTemperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.trailing).offset(-40)
            $0.centerY.equalTo(self.contentView)
        }

        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(0.4)
            $0.leading.equalTo(self).offset(20)
            $0.trailing.equalTo(self).offset(-10)
            $0.bottom.equalTo(self).offset(1)
        }
    }
}
