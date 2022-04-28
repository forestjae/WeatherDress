//
//  ShortForecastFunction.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum ShortForecastFunction: APIFunction {
    case ultraShortNowcast
    case ultraShortForecast
    case shortForecast

    var path: String {
        switch self {
        case .ultraShortNowcast:
            return "getUltraSrtNcst"
        case .ultraShortForecast:
            return "getUltraSrtFcst"
        case .shortForecast:
            return "getVilageFcst"
        }
    }

    var timeFormatter: DateFormatter {
        switch self {
        case .ultraShortNowcast:
            return DateFormatter.ultraShortNowcastTime
        case .ultraShortForecast:
            return DateFormatter.ultraShortForecastTime
        case .shortForecast:
            return DateFormatter.shortForecastTime
        }
    }
}
