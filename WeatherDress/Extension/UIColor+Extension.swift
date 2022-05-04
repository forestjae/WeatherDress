//
//  UIColor+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/02.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
}

extension UIColor {

    static let lightSky = UIColor(red: 96, green: 144, blue: 206)
    static let moderateSky = UIColor(red: 67, green: 122, blue: 210)
    static let deepSky = UIColor(red: 67, green: 122, blue: 196)
    static let deepSkyDim = UIColor(red: 68, green: 103, blue: 162)
    static let darkSky = UIColor(red: 34, green: 51, blue: 81)
    static let cold = UIColor(red: 136, green: 196, blue: 255)
}
