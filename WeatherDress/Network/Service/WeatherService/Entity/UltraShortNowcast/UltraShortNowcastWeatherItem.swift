//
//  USTWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/04.
//

import Foundation

struct UltraShortNowcastWeatherItem {
    let temperature: Double
    let rainfallForAnHour: Double
    let humidity: Double
    let rainfallType: UltraShortNowcastRainfall

    init?(items: [UltraShortNowcastWeatherComponentItem]) {
        var dict = [UltraShortNowcastWeatherComponent: String]()
        items.forEach { item in
            let category = item.category
            let value = item.observedValue
            guard let component = UltraShortNowcastWeatherComponent(rawValue: category) else {
                return
            }
            dict[component] = value
        }

        guard let temperatureString = dict[.temperature],
              let temperature = Double(temperatureString),
              let rainfallForAnHourString = dict[.rainfallForAnHour],
              let rainfallForAnHour = Double(rainfallForAnHourString),
              let humidityString = dict[.humidity],
              let humidity = Double(humidityString),
              let rainfallTypeString = dict[.rainfallType],
              let rainfallType = UltraShortNowcastRainfall(rawValue: rainfallTypeString)
        else {
            return nil
        }

        self.temperature = temperature
        self.rainfallForAnHour = rainfallForAnHour
        self.humidity = humidity
        self.rainfallType = rainfallType
    }
}
