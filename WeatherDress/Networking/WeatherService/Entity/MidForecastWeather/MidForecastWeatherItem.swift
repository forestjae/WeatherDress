//
//  MidForecastWeatherItem.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation

struct MidForecastWeatherItem {
    let date: Int
    //let beforeNoonWeatehrDescription: String
    let afterNoonWeatherDescription: String
    let weatherCondtion: MidRoughForecast
    //let beforeNoonRainfallProbability: Int
    let afterNoonRainfallProbability: Int

    init(date: Int, afterNoonWeatherDescription: String, afterNoonRainfallProbability: Int) {
        self.date = date
        self.afterNoonWeatherDescription = afterNoonWeatherDescription
        self.afterNoonRainfallProbability = afterNoonRainfallProbability
        self.weatherCondtion = MidRoughForecast(rawValue: self.afterNoonWeatherDescription) ?? .clear
    }

    enum MidRoughForecast: String {
        case clear = "맑음"
        case partlyCloudy = "구름많음"
        case partlyCloudyAndRainy = "구름많고 비"
        case partlyCloudyAndSnowy = "구름많고 눈"
        case partlyCloudyAndSleet = "구름많고 비/눈"
        case partlyCloudyAndShower = "구름많고 소나기"
        case cloudy = "흐림"
        case cloudyAndRainy = "흐리고 비"
        case cloudyAndSnowy = "흐리고 눈"
        case cloudyAndSleet = "흐리고 비/눈"
        case cloudyAndShower = "흐리고 소나기"
    }
}

struct MidForecastWeaherItemList {
    let items: [MidForecastWeatherItem]
}

extension MidForecastWeaherItemList {
    init(response: MidForecastWeatherResponse.Item) {
        self.items = [
            MidForecastWeatherItem(date: 3, afterNoonWeatherDescription: response.forecast3AfterNoon, afterNoonRainfallProbability: response.rainFallProbability3Afternoon),
            MidForecastWeatherItem(date: 4, afterNoonWeatherDescription: response.forecast4AfterNoon, afterNoonRainfallProbability: response.rainFallProbability4Afternoon),
            MidForecastWeatherItem(date: 5, afterNoonWeatherDescription: response.forecast5AfterNoon, afterNoonRainfallProbability: response.rainFallProbability5Afternoon),
            MidForecastWeatherItem(date: 6, afterNoonWeatherDescription: response.forecast6AfterNoon, afterNoonRainfallProbability: response.rainFallProbability6Afternoon),
            MidForecastWeatherItem(date: 7, afterNoonWeatherDescription: response.forecast7AfterNoon, afterNoonRainfallProbability: response.rainFallProbability7Afternoon),
            MidForecastWeatherItem(date: 8, afterNoonWeatherDescription: response.forecast8, afterNoonRainfallProbability: response.rainFallProbability8),
            MidForecastWeatherItem(date: 9, afterNoonWeatherDescription: response.forecast9, afterNoonRainfallProbability: response.rainFallProbability9),
            MidForecastWeatherItem(date: 10, afterNoonWeatherDescription: response.forecast10, afterNoonRainfallProbability: response.rainFallProbability10)
        ]
    }
}
