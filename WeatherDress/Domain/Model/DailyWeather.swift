//
//  DailyWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation

struct DailyWeather: Hashable {
    let date: Date
    let weatherCondition: WeatherCondition
    let rainfallProbability: Int
    let maximumTemperature: Double
    let minimunTemperature: Double
}
