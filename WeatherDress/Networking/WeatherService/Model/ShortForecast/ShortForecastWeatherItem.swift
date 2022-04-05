//
//  USFWeather.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

struct ShortForecastWeatherList {
    let baseDate: Date?
    let forecastList: [ShortForecastWeatherItem]

    init(items: [ShortForecastWeatherComponentItem]) {
        var set = Set<String>()

        items.forEach { item in
            set.insert(item.fcstDate + " " + item.fcstTime)
        }

        let baseDateString = "\(items[0].baseDate) \(items[0].baseTime)"
        self.baseDate = DateFormatter.forecastDateAndTime.date(from: baseDateString)

        var resultArray = [ShortForecastWeatherItem]()

        set.forEach { dateString in
            guard let date = DateFormatter.forecastDateAndTime.date(from: dateString) else {
                return
            }
            let components = dateString.components(separatedBy: " ")
            let forecastDate = components[0]
            let forecastTime = components[1]
            var dict = [ShortForecastWeatherComponent: String]()
            let filtered = items
                .filter { $0.fcstDate == forecastDate && $0.fcstTime == forecastTime }
            filtered.forEach { component in
                let category = component.category
                let value = component.fcstValue
                guard let component = ShortForecastWeatherComponent(rawValue: category) else {
                    return
                }
                dict[component] = value
            }

            guard let result = ShortForecastWeatherItem(
                date: date,
                baseDate: DateFormatter.forecastDateAndTime.date(from: baseDateString)!,
                items: filtered
            ) else {
                return
            }
            resultArray.append(result)
        }
        self.forecastList = resultArray
    }
}

struct ShortForecastWeatherItem {
    let forecastDate: Date
    let baseDate: Date
    let rainfallProbability: Double
    let rainfallType: ShortForecastRainfall
    let rainfallForAnHour: Double
    let skyCondition: SkyCondition
    let temperatureForAnHour: Double
    let dailyMinimumTemperature: Double?
    let dailyMaximumTemperature: Double?
    let windSpeed: Double

    init?(date: Date, baseDate: Date, items: [ShortForecastWeatherComponentItem]) {
        self.forecastDate = date
        self.baseDate = baseDate

        var dict = [ShortForecastWeatherComponent: String]()
        items.forEach { item in
            let category = item.category
            let value = item.fcstValue
            guard let component = ShortForecastWeatherComponent(rawValue: category) else {
                return
            }
            dict[component] = value
        }

        guard let rainfallProbabilityString = dict[.rainfallProbability],
              let rainfallProbability = Double(rainfallProbabilityString),
              let rainfallTypeString = dict[.rainfallType],
              let rainfallType = ShortForecastRainfall(rawValue: rainfallTypeString),
              let rainfallForAnHourString = dict[.rainfallForAnHour],
              let skyConditionString = dict[.skyCondition],
              let skyCondition = SkyCondition(rawValue: skyConditionString),
              let temperatureForAnHourString = dict[.temperatureForAnHour],
              let temperatureForAnHour = Double(temperatureForAnHourString),
              let dailyMinimunTemperature = Double(dict[.dailyMinimumTemperature, default: "0"]),
              let dailyMaximumTemperature = Double(dict[.dailyMaximumTemperature, default: "0"]),
              let windSpeedString = dict[.windSpeed],
              let windSpeed = Double(windSpeedString)
        else {
            return nil
        }

        self.rainfallProbability = rainfallProbability
        self.rainfallType = rainfallType
        self.rainfallForAnHour = Double(rainfallForAnHourString) ?? 0
        self.skyCondition = skyCondition
        self.temperatureForAnHour = temperatureForAnHour
        self.dailyMinimumTemperature = dailyMinimunTemperature
        self.dailyMaximumTemperature = dailyMaximumTemperature
        self.windSpeed = windSpeed
    }
}
