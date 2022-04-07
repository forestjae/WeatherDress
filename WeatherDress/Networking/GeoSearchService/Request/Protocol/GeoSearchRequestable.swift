//
//  ShortForecastRequestable.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

protocol GeoSerachRequestable: APIRequest {
    var function: GeoSearchFunction { get }
}

extension GeoSerachRequestable {
    var baseURL: URL? {
        return GeoSearchAPIInfo.geoSearch.urlString
    }
}
