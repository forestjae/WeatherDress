//
//  MidForecastWeatherResponse.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct MidForecastWeatherResponse: APIResponse {
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
        let regIdentification: String
        let rainFallProbability3BeforeNoon: Int
        let rainFallProbability3Afternoon: Int
        let rainFallProbability4BeforeNoon: Int
        let rainFallProbability4Afternoon: Int
        let rainFallProbability5BeforeNoon: Int
        let rainFallProbability5Afternoon: Int
        let rainFallProbability6BeforeNoon: Int
        let rainFallProbability6Afternoon: Int
        let rainFallProbability7BeforeNoon: Int
        let rainFallProbability7Afternoon: Int
        let rainFallProbability8: Int
        let rainFallProbability9: Int
        let rainFallProbability10: Int
        let forecast3BeforeNoon: String
        let forecast3AfterNoon: String
        let forecast4BeforeNoon: String
        let forecast4AfterNoon: String
        let forecast5BeforeNoon: String
        let forecast5AfterNoon: String
        let forecast6BeforeNoon: String
        let forecast6AfterNoon: String
        let forecast7BeforeNoon: String
        let forecast7AfterNoon: String
        let forecast8: String
        let forecast9: String
        let forecast10: String

        enum CodingKeys: String, CodingKey {
            case regIdentification = "regId"
            case rainFallProbability3BeforeNoon = "rnSt3Am"
            case rainFallProbability3Afternoon = "rnSt3Pm"
            case rainFallProbability4BeforeNoon = "rnSt4Am"
            case rainFallProbability4Afternoon = "rnSt4Pm"
            case rainFallProbability5BeforeNoon = "rnSt5Am"
            case rainFallProbability5Afternoon = "rnSt5Pm"
            case rainFallProbability6BeforeNoon = "rnSt6Am"
            case rainFallProbability6Afternoon = "rnSt6Pm"
            case rainFallProbability7BeforeNoon = "rnSt7Am"
            case rainFallProbability7Afternoon = "rnSt7Pm"
            case rainFallProbability8 = "rnSt8"
            case rainFallProbability9 = "rnSt9"
            case rainFallProbability10 = "rnSt10"
            case forecast3BeforeNoon = "wf3Am"
            case forecast3AfterNoon = "wf3Pm"
            case forecast4BeforeNoon = "wf4Am"
            case forecast4AfterNoon = "wf4Pm"
            case forecast5BeforeNoon = "wf5Am"
            case forecast5AfterNoon = "wf5Pm"
            case forecast6BeforeNoon = "wf6Am"
            case forecast6AfterNoon = "wf6Pm"
            case forecast7BeforeNoon = "wf7Am"
            case forecast7AfterNoon = "wf7Pm"
            case forecast8 = "wf8"
            case forecast9 = "wf9"
            case forecast10 = "wf10"
        }
    }
}
