//
//  SettingSegmentedControl.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/11.
//
import UIKit

final class SettingSegmentedControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    private func configure() {
        self.selectedSegmentTintColor = .skyWhite
        self.setTitleTextAttributes([.foregroundColor: UIColor.deepDarkGray], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
