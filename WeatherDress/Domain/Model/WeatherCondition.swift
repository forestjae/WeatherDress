//
//  WeatherCondition.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/10.
//

import Foundation

enum WeatherCondition {
    case clear
    case partlyCloudy
    case cloudy
    case rain
    case snow
}

extension WeatherCondition {
    var description: String {
        switch self {
        case .clear:
            return "청명함"
        case .partlyCloudy:
            return "구름많음"
        case .cloudy:
            return "흐림"
        case .rain:
            return "비"
        case .snow:
            return "눈"
        }
    }

    var staticImageURL: String {
        switch self {
        case .clear:
            return "Sunny"
        case .partlyCloudy:
            return "PartlyCloudy"
        case .cloudy:
            return "Cloudy"
        case .rain:
            return "Rain"
        case .snow:
            return "Snow"
        }
    }

    var animatedImageURL: String? {
        switch self {
        case .clear:
            return "Sunny_Animated"
        case .partlyCloudy:
            return "PartlyCloudy_Animated"
        case .rain:
            return "Rain_Animated"
        case .snow:
            return "Snow_Animated"
        default:
            return nil
        }
    }
}
