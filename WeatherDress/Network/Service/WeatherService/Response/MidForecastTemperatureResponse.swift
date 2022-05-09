//
//  MidForecastTemperatureResponse.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct MidForecastTemperatureResponse: APIResponse {
    let response: Response

    struct Response: Decodable {
        let header: Header
        let body: Body
    }

    struct Header: Decodable {
        let resultCode, resultMsg: String
    }

    struct Body: Decodable {
        let dataType: String
        let items: Items
        let pageNo, numOfRows, totalCount: Int
    }

    struct Items: Decodable {
        let item: [Item]
    }

    struct Item: Decodable {
        let regionIdentifier: String
        let temparatureMin3: Double
        let temparatureMax3: Double
        let temparatureMin4: Double
        let temparatureMax4: Double
        let temparatureMin5: Double
        let temparatureMax5: Double
        let temparatureMin6: Double
        let temparatureMax6: Double
        let temparatureMin7: Double
        let temparatureMax7: Double
        let temparatureMin8: Double
        let temparatureMax8: Double
        let temparatureMin9: Double
        let temparatureMax9: Double
        let temparatureMin10: Double
        let temparatureMax10: Double

        enum CodingKeys: String, CodingKey {
            case regionIdentifier = "regId"
            case temparatureMin3 = "taMin3"
            case temparatureMax3 = "taMax3"
            case temparatureMin4 = "taMin4"
            case temparatureMax4 = "taMax4"
            case temparatureMin5 = "taMin5"
            case temparatureMax5 = "taMax5"
            case temparatureMin6 = "taMin6"
            case temparatureMax6 = "taMax6"
            case temparatureMin7 = "taMin7"
            case temparatureMax7 = "taMax7"
            case temparatureMin8 = "taMin8"
            case temparatureMax8 = "taMax8"
            case temparatureMin9 = "taMin9"
            case temparatureMax9 = "taMax9"
            case temparatureMin10 = "taMin10"
            case temparatureMax10 = "taMax10"
        }
    }
}
