//
//  DailyWeatherTableViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import UIKit

class DailyWeaterTableViewCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
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
        imageView.image = UIImage(named: "Sunny")
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
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.timeLabel)
        self.stackView.addArrangedSubview(self.skyConditionImageView)
        self.stackView.addArrangedSubview(self.maxTemperatureLabel)
        self.stackView.addArrangedSubview(self.minTemperatureLabel)
    }

    private func configureConstraint() {
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.contentView)
        }
        self.skyConditionImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
    }
}
