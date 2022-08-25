//
//  DailyWeatherItemViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/04.
//

import Foundation

struct DailyWeatherItemViewModel: Hashable {
    let dateDescription: String
    let dayOfWeek: String
    let weatherImageURL: String
    let minTemperature: String
    let maxTemperature: String

    enum DateDescription {
        case today
        case tommorrow
        case theDayAfterTommorrow
        case date(Date)

        var description: String {
            switch self {
            case .today:
                return "오늘"
            case .tommorrow:
                return "내일"
            case .theDayAfterTommorrow:
                return "모레"
            case .date(let date):
                return DateFormatter.dailyWeatherDate.string(from: date)
            }
        }
    }
}

extension DailyWeatherItemViewModel {
    init(dailyWeather: DailyWeather, index: Int) {
        switch index {
        case 0:
            self.dateDescription = DateDescription.today.description
        case 1:
            self.dateDescription = DateDescription.tommorrow.description
        case 2:
            self.dateDescription = DateDescription.theDayAfterTommorrow.description
        default:
            self.dateDescription = DateDescription.date(dailyWeather.date).description
        }
        self.dayOfWeek = DateFormatter.dayOfWeekDate.string(from: dailyWeather.date)
        self.minTemperature = dailyWeather.minimunTemperature.celsiusExpression
        self.maxTemperature = dailyWeather.maximumTemperature.celsiusExpression
        self.weatherImageURL = dailyWeather.weatherCondition.staticImageURL
    }
}
