//
//  CurrentWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation

struct CurrentWeather {
    let temperature: Int
    let skyCondition: SkyCondition2
    let description: String
    let maximumTemperature: Int
    let minimunTemperature: Int
}

enum SkyCondition2 {
    case clear
    case cloudy
    case cloudyAndRain
    case rain
    case heavyRain
    case snow
    case sleet
}
