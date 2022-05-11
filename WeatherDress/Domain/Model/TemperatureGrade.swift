//
//  TemperatureGrade.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/11.
//

import Foundation

enum TemperatureGrade {
    case bitterCold
    case freezingCold
    case veryCold
    case cold
    case chill
    case coolness
    case moderate
    case warmth
    case heat
    case intenseHeat

    var temperatureRange: Range<Double> {
        switch self {
        case .bitterCold:
            return -100.0..<(-7.0)
        case .freezingCold:
            return -7.0..<0.0
        case .veryCold:
            return 0.0..<5.0
        case .cold:
            return 5.0..<9.0
        case .chill:
            return 9.0..<12.0
        case .coolness:
            return 12.0..<17.0
        case .moderate:
            return 17.0..<20.0
        case .warmth:
            return 20.0..<22.0
        case .heat:
            return 23.0..<28.0
        case .intenseHeat:
            return 28.0..<50
        }
    }
}
