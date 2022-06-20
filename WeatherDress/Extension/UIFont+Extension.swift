//
//  Font+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/28.
//

import UIKit

extension UIFont {
    func metrics(for textStyle: UIFont.TextStyle) -> UIFont {
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: self)
    }
}
