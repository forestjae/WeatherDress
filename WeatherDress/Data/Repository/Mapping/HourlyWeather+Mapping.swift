//
//  HourlyWeather+Mapping.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/03.
//

import Foundation

extension HourlyWeather {
    init(ultraShortForecast: UltraShortForecastWeatherItem) {
        self.init(
            date: ultraShortForecast.forecastDate,
            weatherCondition: Self.convertedFrom(
                ultraShortForecast.skyCondition,
                rainFall: ultraShortForecast.rainfallType
            ),
            temperature: ultraShortForecast.temperature
        )
    }

    init(shortForecast: ShortForecastWeatherItem) {
        self.init(
            date: shortForecast.forecastDate,
            weatherCondition: Self.convertedFrom(
                shortForecast.skyCondition,
                rainFall: shortForecast.rainfallType
            ),
            temperature: shortForecast.temperatureForAnHour
        )
    }

    static func convertedFrom(
        _ skyCondtion: SkyCondition,
        rainFall: ShortForecastRainfall
    ) -> WeatherCondition {
        switch (skyCondtion, rainFall) {
        case (.clear, .none):
            return .clear
        case (.cloudy, .none):
            return .partlyCloudy
        case (.hazy, .none):
            return .cloudy
        case (.clear, .rain), (.clear, .shower), (.cloudy, .rain), (.cloudy, .shower),
            (.hazy, .rain), (.hazy, .shower):
            return .rain
        case (.clear, .snow), (.clear, .snowAndRain), (.cloudy, .snow), (.cloudy, .snowAndRain),
            (.hazy, .snow), (.hazy, .snowAndRain):
            return .snow
        }
    }

    static func convertedFrom(
        _ skyCondtion: SkyCondition,
        rainFall: UltraShortNowcastRainfall
    ) -> WeatherCondition {
        switch (skyCondtion, rainFall) {
        case (.clear, .none):
            return .clear
        case (.cloudy, .none):
            return .partlyCloudy
        case (.hazy, .none):
            return .cloudy
        case (.clear, .rain), (.clear, .raindrops), (.cloudy, .rain), (.cloudy, .raindrops),
            (.hazy, .rain), (.hazy, .raindrops) :
            return .rain
        case (.clear, .snow), (.clear, .snowAndRain), (.clear, .raindropsAndSnowflakes),
            (.clear, .snowflakes), (.cloudy, .snow), (.cloudy, .snowAndRain),
            (.cloudy, .raindropsAndSnowflakes), (.cloudy, .snowflakes), (.hazy, .snow),
            (.hazy, .snowAndRain), (.hazy, .raindropsAndSnowflakes), (.hazy, .snowflakes):
            return .snow
        }
    }
}
