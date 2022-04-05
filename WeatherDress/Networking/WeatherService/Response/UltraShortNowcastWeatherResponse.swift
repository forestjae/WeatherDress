//
//  WeatherResult.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/04.
//

import Foundation

struct UltraShortNowcastWeatherResponse: Codable {
    let response: ResponseResult

    struct ResponseResult: Codable {
        let header: Header
        let body: Body?
    }

    struct Body: Codable {
        let dataType: String
        let items: Items
        let pageNo, numOfRows, totalCount: Int
    }

    struct Items: Codable {
        let item: [UltraShortNowcastWeatherComponentItem]
    }

    struct Header: Codable {
        let resultCode, resultMsg: String
    }
}

struct UltraShortNowcastWeatherComponentItem: Codable {
    let baseDate, baseTime: String
    let category: String
    let nx, ny: Int
    let obsrValue: String
}
