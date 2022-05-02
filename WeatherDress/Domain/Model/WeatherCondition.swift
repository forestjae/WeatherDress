//
//  WeatherCondition.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/10.
//

import Foundation

enum WeatherCondition: String {
    case clear = "청명함"
    case partlyCloudy = "구름많음"
    case cloudy = "흐림"
    case rain = "비"
    case snow = "눈"
}

extension WeatherCondition {
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
