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
    //let beforeNoonRainfallProbability: Int
    let afterNoonRainfallProbability: Int
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
