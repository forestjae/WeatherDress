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

final class DailyWeaterCollectionViewCell: UICollectionViewCell {

    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        let custom = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: custom)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        let custom = UIFont.systemFont(ofSize: 12, weight: .bold)
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
        label.font = .systemFont(ofSize: 18, weight: .medium).metrics(for: .body)
        return label
    }()

    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = .systemFont(ofSize: 18, weight: .medium).metrics(for: .body)
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

    func configureContent(with viewModel: DailyWeatherItemViewModel, index: Int) {
        self.dayOfWeekLabel.text = viewModel.dayOfWeek
        self.timeLabel.text = viewModel.dateDescription.description
        self.minTemperatureLabel.text = viewModel.minTemperature
        self.maxTemperatureLabel.text = viewModel.maxTemperature
        self.skyConditionImageView.image = UIImage(named: viewModel.weatherImageURL)

        if index == 10 {
            self.separatorView.isHidden = true
        }
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
