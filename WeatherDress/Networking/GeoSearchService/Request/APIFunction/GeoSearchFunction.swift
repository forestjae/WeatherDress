//
//  GeocodeFunction.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

enum GeoSearchFunction: APIFunction {
    case geocode
    case addressSearch

    var path: String {
        switch self {
        case .geocode:
            return "geo/coord2regioncode.json"
        case .addressSearch:
            return "search/address.json"
        }
    }
}
