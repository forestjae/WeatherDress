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
    private let clotingTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.mainFont
        label.textColor = Design.mainFontColor
        label.textAlignment = .left
        return label
    }()

    let allClotingButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        return button
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
            $0.top.equalTo(self)
            $0.trailing.equalTo(self).offset(-10)
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
