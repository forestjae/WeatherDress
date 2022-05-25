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
        button.setTitle("다시추천받기", for: .normal)
        return button
    }()

    let clotingDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let timeDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()

    let timeConfigurationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.separatorView)
        self.addSubview(self.clotingDescriptionLabel)
        self.addSubview(self.randomButton)
        self.addSubview(self.timeDescriptionLabel)
        self.addSubview(self.timeConfigurationButton)
        self.configureConstraint()
    }

    private func configureConstraint() {
        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(0.4)
            $0.width.equalTo(self)
            $0.leading.equalTo(self)
            $0.bottom.equalTo(self).offset(1)
        }

        self.randomButton.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.trailing.equalTo(self).offset(-10)
        }

        self.clotingDescriptionLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }

        self.timeDescriptionLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self)
        }

        self.timeConfigurationButton.snp.makeConstraints {
            $0.leading.equalTo(self.timeDescriptionLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(self.timeDescriptionLabel)
        }
    }

    func configure(for message: String) {
        self.clotingDescriptionLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
