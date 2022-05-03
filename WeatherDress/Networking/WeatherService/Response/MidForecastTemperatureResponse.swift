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
        let temparatureMin3: Int
        let temparatureMax3: Int
        let temparatureMin4: Int
        let temparatureMax4: Int
        let temparatureMin5: Int
        let temparatureMax5: Int
        let temparatureMin6: Int
        let temparatureMax6: Int
        let temparatureMin7: Int
        let temparatureMax7: Int
        let temparatureMin8: Int
        let temparatureMax8: Int
        let temparatureMin9: Int
        let temparatureMax9: Int
        let temparatureMin10: Int
        let temparatureMax10: Int

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
