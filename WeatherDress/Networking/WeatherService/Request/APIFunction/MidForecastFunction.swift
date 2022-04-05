//
//  MidForecastFunction.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum MidForecastFunction: APIFunction {
    case midOverallForecast
    case midLandForecast
    case midTemperatureForecast

    var path: String {
        switch self {
        case .midOverallForecast:
            return "getMidFcst"
        case .midLandForecast:
            return "getMidLandFcst"
        case .midTemperatureForecast:
            return "getMidTa"
        }
    }
}
