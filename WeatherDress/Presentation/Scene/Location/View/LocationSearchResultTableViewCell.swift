//
//  LocationSearchResultTableViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import UIKit

final class LocationSearchResultTableViewCell: UITableViewCell {
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
        self.configureHierarchy()
        self.configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with string: String, searchQuery: String?) {
        guard let searchQuery = searchQuery else {
            return
        }

        let attribtuedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: searchQuery)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        self.locationLabel.attributedText = attribtuedString
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.locationLabel)
    }

    private func configureConstraint() {
        self.locationLabel.snp.makeConstraints {
            $0.leading.equalTo(self.contentView).offset(40)
            $0.centerY.equalTo(self.contentView)
        }
    }
}
