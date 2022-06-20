//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFontColor: UIColor = .white
    static let timeLabelFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        .metrics(for: .headline)
    static let temperatureLabelFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
        .metrics(for: .headline)
}

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = Design.timeLabelFont
        return label
    }()

    private let skyConditionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = Design.temperatureLabelFont
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: HourlyWeatherItemViewModel) {
        self.timeLabel.text = viewModel.timeDescription.description
        self.temperatureLabel.text = viewModel.temperature
        self.skyConditionImageView.image = UIImage(named: viewModel.weatherImageURL)
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
        self.temperatureLabel.snp.contentHuggingVerticalPriority = 0
        self.skyConditionImageView.snp.makeConstraints {
            $0.width.height.equalTo(33)
        }
    }
}
