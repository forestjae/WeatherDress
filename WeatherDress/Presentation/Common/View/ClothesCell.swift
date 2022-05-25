//
//  ClothesCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFontColor: UIColor = .black
    static let timeLabelFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        .metrics(for: .headline)
    static let temperatureLabelFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
        .metrics(for: .headline)
}

class ClothesCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mainFontColor
        label.font = Design.timeLabelFont
        return label
    }()

    private let clothesImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white.withAlphaComponent(0.5)
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowOpacity = 0.3
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureContent(with viewModel: ClothesItemViewModel) {
        self.nameLabel.text = viewModel.name.localized
        self.clothesImageView.image = UIImage(named: viewModel.name)
    }

    func configureConstraint() {
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.contentView)
        }
        self.clothesImageView.snp.makeConstraints {
            $0.width.height.equalTo(55)
        }
    }

    func configureHierarchy() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.clothesImageView)
    }
}
