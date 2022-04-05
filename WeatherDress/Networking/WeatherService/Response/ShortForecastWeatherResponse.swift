//
//  USFWeatherResult.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

struct ShortForecastWeatherResponse: Codable {
    let response: Response

    struct Response: Codable {
        let header: Header
        let body: Body
    }

    struct Body: Codable {
        let dataType: String
        let items: Items
        let pageNo, numOfRows, totalCount: Int
    }

    struct Items: Codable {
        let item: [ShortForecastWeatherComponentItem]
    }

    struct Header: Codable {
        let resultCode, resultMsg: String
    }
}

struct ShortForecastWeatherComponentItem: Codable {
    let baseDate, baseTime, category, fcstDate: String
    let fcstTime, fcstValue: String
    let nx, ny: Int
}
