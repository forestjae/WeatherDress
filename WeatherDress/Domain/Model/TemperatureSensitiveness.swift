//
//  TemperatureSensitiveness.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import Foundation

enum TemperatureSensitiveness: Int {
    case sensitiveToCold = 0
    case normal = 1
    case sensitiveToHeat = 2

    var temperatureToRevise: Double {
        switch self {
        case .sensitiveToCold:
            return 2.0
        case .normal:
            return 0.0
        case .sensitiveToHeat:
            return -2.0
        }
    }
}
