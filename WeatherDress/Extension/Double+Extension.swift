//
//  Double+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/04.
//

import Foundation

extension Double {
    var celsiusExpression: String {
        return String(Int(self)) + "°"
    }
}
