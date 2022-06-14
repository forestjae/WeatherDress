//
//  Int+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/13.
//

import Foundation

extension Int {
    func convertToFourDigit() -> String {
        if self > 9 {
            return String(self) + "00"
        } else {
            return "0" + String(self) + "00"
        }
    }
}
