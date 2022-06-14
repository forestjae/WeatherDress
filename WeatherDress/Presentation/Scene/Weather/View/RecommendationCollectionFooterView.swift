//
//  ClothingCollectionFooterView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/21.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFont: UIFont = .systemFont(ofSize: 14, weight: .bold).metrics(for: .body)
    static let mainFontColor: UIColor = .cold
}

class RecommendationCollectionFooterView: UICollectionReusableView {
    let randomButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 22), forImageIn: .normal)
        button.tintColor = .white
        return button
    }()

    let clotingDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold).metrics(for: .title3)
        label.textColor = .white
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.separatorView)
        self.addSubview(self.clotingDescriptionLabel)
        self.addSubview(self.randomButton)
        self.configureConstraint()
    }

    private func configureConstraint() {
        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(0.4)
            $0.width.equalTo(self)
            $0.leading.equalTo(self)
            $0.top.equalTo(self).offset(27)
        }

        self.randomButton.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.trailing.equalTo(self).offset(-12)
        }

        self.clotingDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(30)
            $0.centerX.equalTo(self)
        }
    }

    func configure(for message: String) {
        self.clotingDescriptionLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
