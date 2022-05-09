//
//  GeocodeAPIInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

enum GeoSearchAPIInfo: String {
    case geoSearch

    var urlString: URL? {
        switch self {
        case .geoSearch:
            return URL(string: "https://dapi.kakao.com/v2/local/")
        }
    }
}
