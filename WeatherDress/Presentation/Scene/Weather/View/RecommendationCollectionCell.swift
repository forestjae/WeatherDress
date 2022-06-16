//
//  RecommendationCollectionCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import SnapKit

class RecommendationCollectionCell: ClothesCell {
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 11)
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.opacity = 0.8
        label.textAlignment = .center
        return label
    }()

    override func configureHierarchy() {
        super.configureHierarchy()
        self.contentView.addSubview(self.categoryLabel)
    }

    override func configureConstraint() {
        super.configureConstraint()
        self.categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.contentView).offset(-6)
            $0.trailing.equalTo(self.contentView).offset(-5)
            $0.width.equalTo(36)
            $0.height.equalTo(15)
        }
    }

    override func configureContent(with viewModel: ClothesItemViewModel) {
        super.configureContent(with: viewModel)
        self.categoryLabel.text = viewModel.type.description
    }
}
