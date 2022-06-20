//
//  Calendar+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/04.
//

import Foundation

extension Calendar {
    static func day(from date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: date).day
    }

    static var today: Int? {
        return Self.current.dateComponents([.day], from: Date()).day
    }

    static var tommorrow: Int? {
        return Self.current.dateComponents([.day], from: Date() + 3600 * 24).day
    }

    static var theDayAfterTommorrow: Int? {
        return Self.current.dateComponents([.day], from: Date() + 3600 * 48).day
    }
}
