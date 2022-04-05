//
//  Date+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

extension Date {
    func convert(to formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
