//
//  WeatherResult.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/04.
//

import Foundation

struct UltraShortNowcastWeatherResponse: APIResponse {
    let response: ResponseResult

    struct ResponseResult: Decodable {
        let header: Header
        let body: Body?
    }

    struct Body: Decodable {
        let dataType: String
        let items: Items
        let pageNo, numOfRows, totalCount: Int
    }

    struct Items: Decodable {
        let item: [UltraShortNowcastWeatherComponentItem]
    }

    struct Header: Decodable {
        let resultCode, resultMsg: String
    }
}

struct UltraShortNowcastWeatherComponentItem: Decodable {
    let baseDate: String
    let baseTime: String
    let category: String
    let observedValue: String
    let numberOfX: Int
    let numberOfY: Int

    enum CodingKeys: String, CodingKey {
        case baseDate, baseTime, category
        case observedValue = "obsrValue"
        case numberOfX = "nx"
        case numberOfY = "ny"
    }
}
