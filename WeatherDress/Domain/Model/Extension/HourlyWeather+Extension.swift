//
//  HourlyWeather+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/13.
//

import Foundation

extension HourlyWeather {
    init(currentWeather: CurrentWeather) {
        self.init(
            date: Date(),
            weatherCondition: currentWeather.weatherCondition,
            temperature: currentWeather.temperature
        )
    }
}

extension Sequence where Element == HourlyWeather {
    func toDaily() -> [DailyWeather] {
        let todayItems = self
            .filter { Calendar.day(from: $0.date) == Calendar.today }
        let tommorowItems = self
            .filter { Calendar.day(from: $0.date) == Calendar.tommorrow }
        let theDayAfterTommorrowItems = self
            .filter { Calendar.day(from: $0.date) == Calendar.theDayAfterTommorrow }
        return [todayItems, tommorowItems, theDayAfterTommorrowItems]
            .compactMap { items -> DailyWeather? in
                let temperatureList = items.map { $0.temperature }
                guard let maxTemp = temperatureList.max(),
                      let minTemp = temperatureList.min(),
                      let first = items.first else {
                          return nil
                      }
                let weatherConditionList = items.map { $0.weatherCondition }
                var weatherConditionDict = [WeatherCondition: Int]()
                weatherConditionList.forEach { weatherConditionDict[$0, default: 0] += 1 }
                guard let dailyWeatherCondition = weatherConditionDict
                    .sorted(by: { $0.value > $1.value } )
                    .first?.key
                else {
                    return nil
                }
                
                return DailyWeather(
                    date: first.date,
                    weatherCondition: dailyWeatherCondition,
                    rainfallProbability: 0,
                    maximumTemperature: maxTemp,
                    minimunTemperature: minTemp
                )
            }
    }
}
