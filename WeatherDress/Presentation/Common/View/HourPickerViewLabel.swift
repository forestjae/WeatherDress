//
//  HourPickerViewLabel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/17.
//

import UIKit

final class HourPickerViewLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func configureContent(for date: Date) {
        let dayDescription = Calendar.day(from: date) == Calendar.today ? "" : "다음날"
        self.text = dayDescription + " " + date.convert(to: .hourlyTime)
    }

    private func configure() {
        self.font = .preferredFont(forTextStyle: .subheadline)
        self.textAlignment = .center
        self.textColor = .black
    }
}
