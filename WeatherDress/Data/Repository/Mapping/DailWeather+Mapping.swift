//
//  DailWeather+Mapping.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/03.
//

import Foundation

extension DailyWeather {
    init(
        midWeatherForecast: MidForecastWeatherItem,
        midTemperatureForecast: MidForecastTemperatureItem
    ) {
        self.init(date: Date(timeIntervalSinceNow: Double(midWeatherForecast.date * 3600 * 24)),
                  weatherCondition: Self.convertedFrom(midWeatherForecast.weatherCondtion),
                  rainfallProbability: midWeatherForecast.afterNoonRainfallProbability,
                  maximumTemperature: midTemperatureForecast.maxTemperature,
                  minimunTemperature: midTemperatureForecast.minTemperature
        )
    }

    static func convertedFrom(_ forecast: RoughWeatherCondition) -> WeatherCondition {
        switch forecast {
        case .clear:
            return .clear
        case .partlyCloudy:
            return .partlyCloudy
        case .cloudy:
            return .cloudy
        case .cloudyAndRainy, .cloudyAndShower, .partlyCloudyAndRainy, .partlyCloudyAndShower:
            return .rain
        case .cloudyAndSnowy, .partlyCloudyAndSnowy, .cloudyAndSleet, .partlyCloudyAndSleet:
            return .snow
        }
    }
}
