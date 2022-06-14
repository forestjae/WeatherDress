//
//  RecommendationCollectionHeaderView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFont: UIFont = .systemFont(ofSize: 14, weight: .bold).metrics(for: .body)
    static let mainFontColor: UIColor = .cold
}

class RecommendationCollectionHeaderView: UICollectionReusableView {
    let slider: RangeSlider = {
      let slider = RangeSlider()
      slider.minValue = 5
      slider.maxValue = 28
      return slider
    }()

    private let clotingTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.mainFont
        label.textColor = Design.mainFontColor
        label.textAlignment = .left
        label.attributedText = "".attach(with: "location", pointSize: 10, tintColor: .cold)
        return label
    }()

    let allClotingButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold).metrics(for: .callout)
        return button
    }()

    let leaveReturnTimeLabel: TimeLabel = {
        let label = TimeLabel()
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.clotingTypeTitleLabel)
        self.addSubview(self.separatorView)
        self.addSubview(self.allClotingButton)
        self.addSubview(self.slider)
        self.addSubview(self.leaveReturnTimeLabel)
        self.configureConstraint()
    }

    private func configureConstraint() {
        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(0.4)
            $0.width.equalTo(self)
            $0.leading.equalTo(self)
            $0.bottom.equalTo(self).offset(1)
        }

        self.allClotingButton.snp.makeConstraints {
            $0.centerY.equalTo(self.clotingTypeTitleLabel)
            $0.trailing.equalTo(self).offset(-10)
        }

        self.slider.snp.makeConstraints {
            $0.top.equalTo(self.clotingTypeTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self).offset(10)
            $0.width.equalTo(250)
            $0.height.equalTo(30)
        }

        self.leaveReturnTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(self.slider.snp.trailing).offset(5)
            $0.centerY.equalTo(self.slider)
        }
    }

    func configure(for section: RecommendationSection) {
        self.clotingTypeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }
        self.clotingTypeTitleLabel.text = section.title
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
