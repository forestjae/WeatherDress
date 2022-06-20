//
//  HourlyCollectionReusableView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/29.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFont: UIFont = .systemFont(ofSize: 14, weight: .bold).metrics(for: .body)
    static let mainFontColor: UIColor = .cold
}

final class HourlyCollectionReusableView: UICollectionReusableView {
    private let hourlyWeatherTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.mainFont
        label.textColor = Design.mainFontColor
        label.textAlignment = .left
        return label
    }()

    private let minTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최저"
        label.font = .systemFont(ofSize: 16, weight: .bold).metrics(for: .body)
        label.textColor = .white
        return label
    }()

    private let maxTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최고"
        label.font = .systemFont(ofSize: 16, weight: .bold).metrics(for: .body)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.hourlyWeatherTitleLabel)
        self.addSubview(self.separatorView)
        self.addSubview(minTitleLabel)
        self.addSubview(maxTitleLabel)
        self.configureConstraint()
    }

    private func configureConstraint() {
        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(0.4)
            $0.width.equalTo(self)
            $0.leading.equalTo(self)
            $0.bottom.equalTo(self).offset(1)
        }
    }

    func configure(for section: WeatherSection) {
        self.hourlyWeatherTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }

        switch section {
        case .hourly:
            self.hourlyWeatherTitleLabel.attributedText = "시간별 예보".attach(
                with: "clock.circle.fill",
                pointSize: 14,
                tintColor: .cold
            )

            self.maxTitleLabel.isHidden = true
            self.minTitleLabel.isHidden = true
        case .daily:
            self.hourlyWeatherTitleLabel.attributedText = "일별 예보".attach(
                with: "calendar",
                pointSize: 14,
                tintColor: .cold
            )

            self.minTitleLabel.snp.makeConstraints {
                $0.top.equalTo(self).offset(10)
                $0.trailing.equalTo(self).offset(-60)
            }

            self.maxTitleLabel.snp.makeConstraints {
                $0.top.equalTo(self).offset(10)
                $0.trailing.equalTo(self).offset(-16)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
