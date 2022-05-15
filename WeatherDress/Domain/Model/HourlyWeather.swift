//
//  HourlyWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation

struct HourlyWeather: Hashable {
    let date: Date
    let weatherCondition: WeatherCondition
    let temperature: Double
}
