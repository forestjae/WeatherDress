//
//  LocationTableViewCell.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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

    func configure(with locationInfo: LocationInfo, indexPath: Int) {
        self.locationLabel.text = locationInfo.address.fullAddress
    }

    private func configureCell() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.locationLabel)
    }

    private func configureConstraint() {
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.contentView)
        }
    }
}
