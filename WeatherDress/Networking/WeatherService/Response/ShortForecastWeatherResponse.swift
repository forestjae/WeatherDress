//
//  USFWeatherResult.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

struct ShortForecastWeatherResponse: APIResponse {
    let response: Response

    struct Response: Decodable {
        let header: Header
        let body: Body
    }

    struct Body: Decodable {
        let dataType: String
        let items: Items
        let pageNo, numOfRows, totalCount: Int
    }

    struct Items: Decodable {
        let item: [ShortForecastWeatherComponentItem]
    }

    struct Header: Decodable {
        let resultCode, resultMsg: String
    }
}

struct ShortForecastWeatherComponentItem: Decodable {
    let baseDate: String
    let baseTime: String
    let category: String
    let forecastDate: String
    let forecastTime: String
    let forecastValue: String
    let numberOfX: Int
    let numberOfY: Int

    enum CodingKeys: String, CodingKey {
        case baseDate, baseTime, category
        case forecastDate = "fcstDate"
        case forecastTime = "fcstTime"
        case forecastValue = "fcstValue"
        case numberOfX = "nx"
        case numberOfY = "ny"
    }
}
