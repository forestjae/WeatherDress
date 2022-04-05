//
//  ShortForecastRequestable.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

protocol ShortForecastRequestable: APIRequest {
    var function: ShortForecastFunction { get }
}

extension ShortForecastRequestable {
    var baseURL: URL? {
        return WeatherForecastAPIInfo.shortForecast.urlString
    }
}
