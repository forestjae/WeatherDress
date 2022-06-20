//
//  TimeLabel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/10.
//

import UIKit

final class TimeLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLabel()
    }

    func configureLabel() {
        self.font = .systemFont(ofSize: 12, weight: .semibold).metrics(for: .caption1)
        self.textColor = .deepDarkGray
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.opacity = 0.8
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.systemGray2.cgColor
        self.textAlignment = .center
        self.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(24)
        }
    }
}
