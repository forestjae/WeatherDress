//
//  MidForecastRequestable.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

protocol MidForecastRequestable: APIRequest {
    var function: MidForecastFunction { get }
}

extension MidForecastRequestable {
    var baseURL: URL? {
        return WeatherForecastAPIInfo.shortForecast.urlString
    }
}
