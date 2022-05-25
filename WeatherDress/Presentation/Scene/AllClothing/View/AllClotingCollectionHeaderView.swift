//
//  AllClotingCollectionHeaderView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/16.
//

import UIKit
import SnapKit

private enum Design {
    static let mainFont: UIFont = .systemFont(ofSize: 14, weight: .bold).metrics(for: .body)
    static let mainFontColor: UIColor = .cold
}

class AllClotingCollectionHeaderView: UICollectionReusableView {
    private let clotingTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.mainFont
        label.textColor = Design.mainFontColor
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
        self.addSubview(self.clotingTypeTitleLabel)
        self.addSubview(self.separatorView)
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

    func configure(for section: ClotingSection) {
        self.clotingTypeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }
        self.clotingTypeTitleLabel.text = section.title
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
