//
//  CurrentWeather+Mapping.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/03.
//

import Foundation

extension CurrentWeather {
    init(
        ultraShortNowcast: UltraShortNowcastWeatherItem,
        ultraShortForecast: UltraShortForecastWeatherItem
    ) {
        self.init(
            temperature: ultraShortNowcast.temperature,
            weatherCondition: HourlyWeather.convertedFrom(
                ultraShortForecast.skyCondition,
                rainFall: ultraShortForecast.rainfallType
            ),
            rainfallForAnHour: ultraShortNowcast.rainfallForAnHour,
            rainfallType: ultraShortNowcast.rainfallType,
            humidity: ultraShortNowcast.humidity
        )
    }
}
