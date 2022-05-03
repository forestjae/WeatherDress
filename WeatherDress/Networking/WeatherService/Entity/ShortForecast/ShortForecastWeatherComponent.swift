//
//  ShortForecastWeatherComponent.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum ShortForecastWeatherComponent: String, CaseIterable {
    case rainfallProbability = "POP"
    case rainfallType = "PTY"
    case rainfallForAnHour = "PCP"
    case humidity = "REH"
    case skyCondition = "SKY"
    case temperatureForAnHour = "TMP"
    case dailyMinimumTemperature = "TMN"
    case dailyMaximumTemperature = "TMX"
    case windSpeed = "WSD"
}
