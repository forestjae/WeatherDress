//
//  WeatherForecastAPIInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum WeatherForecastAPIInfo: String {
    case shortForecast
    case midForecast

    var urlString: URL? {
        switch self {
        case .shortForecast:
            return URL(string: "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/")
        case .midForecast:
            return URL(string: "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/")
        }
    }
}
