//
//  CurrentWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation
import RxSwift

struct CurrentWeather: Hashable {
    let temperature: Double
    let rainfallForAnHour: Double
    let rainfallType: UltraShortNowcastRainfall
    let humidity: Double
}
