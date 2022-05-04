//
//  MidForecastTemperatureItem.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation

struct MidForecastTemperatureItem {
    let date: Int
    let maxTemperature: Double
    let minTemperature: Double
}

struct MidForecastTemperatureItemList {
    let items: [MidForecastTemperatureItem]
}

extension MidForecastTemperatureItemList {
    init(response: MidForecastTemperatureResponse.Item) {
        self.items = [
            MidForecastTemperatureItem(date: 3, maxTemperature: response.temparatureMax3, minTemperature: response.temparatureMin3),
            MidForecastTemperatureItem(date: 4, maxTemperature: response.temparatureMax4, minTemperature: response.temparatureMin4),
            MidForecastTemperatureItem(date: 5, maxTemperature: response.temparatureMax5, minTemperature: response.temparatureMin5),
            MidForecastTemperatureItem(date: 6, maxTemperature: response.temparatureMax6, minTemperature: response.temparatureMin6),
            MidForecastTemperatureItem(date: 7, maxTemperature: response.temparatureMax7, minTemperature: response.temparatureMin7),
            MidForecastTemperatureItem(date: 8, maxTemperature: response.temparatureMax8, minTemperature: response.temparatureMin8),
            MidForecastTemperatureItem(date: 9, maxTemperature: response.temparatureMax9, minTemperature: response.temparatureMin9),
            MidForecastTemperatureItem(date: 10, maxTemperature: response.temparatureMax10, minTemperature: response.temparatureMin10)
        ]
    }
}
