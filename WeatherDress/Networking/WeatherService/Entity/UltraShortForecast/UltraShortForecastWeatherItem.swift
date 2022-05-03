//
//  UltraShortForecastWeatherItem.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation

struct UltraShortForecastWeatherList {
    let baseDate: Date?
    let forecastList: [UltraShortForecastWeatherItem]

    init(items: [UltraShortForecastWeatherComponentItem]) {
        var set = Set<String>()

        items.forEach { item in
            set.insert(item.fcstDate + " " + item.fcstTime)
        }

        let baseDateString = "\(items[0].baseDate) \(items[0].baseTime)"
        self.baseDate = DateFormatter.forecastDateAndTime.date(from: baseDateString)

        var resultArray = [UltraShortForecastWeatherItem]()

        set.forEach { dateString in
            guard let date = DateFormatter.forecastDateAndTime.date(from: dateString) else {
                return
            }
            let components = dateString.components(separatedBy: " ")
            let forecastDate = components[0]
            let forecastTime = components[1]
            var dict = [UltraShortForecastWeatherComponent: String]()
            let filtered = items
                .filter { $0.fcstDate == forecastDate && $0.fcstTime == forecastTime }
            filtered.forEach { component in
                let category = component.category
                let value = component.fcstValue
                guard let component = UltraShortForecastWeatherComponent(rawValue: category) else {
                    return
                }
                dict[component] = value
            }

            guard let result = UltraShortForecastWeatherItem(
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

struct UltraShortForecastWeatherItem {
    let forecastDate: Date
    let baseDate: Date
    let temperature: Double
    let rainfallForAnHour: Double
    let humidity: Double
    let skyCondition: SkyCondition
    let rainfallType: UltraShortNowcastRainfall
    let lightning: Double
    let windSpeed: Double

    init?(date: Date, baseDate: Date, items: [ShortForecastWeatherComponentItem]) {
        self.forecastDate = date
        self.baseDate = baseDate

        var dict = [UltraShortForecastWeatherComponent: String]()
        items.forEach { item in
            let category = item.category
            let value = item.fcstValue
            guard let component = UltraShortForecastWeatherComponent(rawValue: category) else {
                return
            }
            dict[component] = value
        }

        guard let temperatureString = dict[.temperature],
              let temperature = Double(temperatureString),
              let rainfallTypeString = dict[.rainfallType],
              let rainfallType = UltraShortNowcastRainfall(rawValue: rainfallTypeString),
              let rainfallForAnHourString = dict[.rainfallForAnHour],
              let skyConditionString = dict[.skyCondition],
              let skyCondition = SkyCondition(rawValue: skyConditionString),
              let humidityString = dict[.humidity],
              let humidity = Double(humidityString),
              let lightningString = dict[.lightning],
              let lightning = Double(lightningString),
              let windSpeedString = dict[.windSpeed],
              let windSpeed = Double(windSpeedString)
        else {
            return nil
        }

        self.temperature = temperature
        self.rainfallForAnHour = Double(rainfallForAnHourString) ?? 0
        self.humidity = humidity
        self.skyCondition = skyCondition
        self.rainfallType = rainfallType
        self.lightning = lightning
        self.windSpeed = windSpeed
    }
}
