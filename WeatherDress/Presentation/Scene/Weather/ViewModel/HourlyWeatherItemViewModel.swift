//
//  HourlyWeatherCellViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/04.
//

import Foundation

struct HourlyWeatherItemViewModel: Hashable {
    let timeDescription: String
    let day: Int?
    let weatherImageURL: String
    let temperature: String

    enum TimeDescription {
        case now
        case time(Date)

        var description: String {
            switch self {
            case .now:
                return "지금"
            case .time(let date):
                return DateFormatter.hourlyWeatherTime.string(from: date)
            }
        }
    }

    init(hourlyWeather: HourlyWeather, index: Int) {
        switch index {
        case 0:
            self.timeDescription = TimeDescription.now.description
        default:
            self.timeDescription = TimeDescription.time(hourlyWeather.date).description
        }
        self.day = Calendar.day(from: hourlyWeather.date)
        self.temperature = hourlyWeather.temperature.celsiusExpression
        self.weatherImageURL = hourlyWeather.weatherCondition.staticImageURL
    }
}
