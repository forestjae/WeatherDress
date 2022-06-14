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
            (.hazy, .rain), (.hazy, .shower), (.clear, .snowAndRain), (.cloudy, .snowAndRain),
            (.hazy, .snowAndRain):
            return .rain
        case (.clear, .snow), (.cloudy, .snow), (.hazy, .snow):
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
            (.hazy, .rain), (.hazy, .raindrops), (.clear, .snowAndRain), (.cloudy, .snowAndRain),
            (.hazy, .raindropsAndSnowflakes), (.hazy, .snowAndRain),
            (.cloudy, .raindropsAndSnowflakes), (.clear, .raindropsAndSnowflakes) :
            return .rain
        case (.clear, .snow), (.clear, .snowflakes), (.cloudy, .snow), (.cloudy, .snowflakes),
            (.hazy, .snow), (.hazy, .snowflakes):
            return .snow
        }
    }
}
