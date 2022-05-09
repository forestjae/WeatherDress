//
//  MidForecastRequestable.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

protocol MidForecastRequestable: APIRequest {}

extension MidForecastRequestable {
    var baseURL: URL? {
        return WeatherForecastAPIInfo.midForecast.urlString
    }
}
