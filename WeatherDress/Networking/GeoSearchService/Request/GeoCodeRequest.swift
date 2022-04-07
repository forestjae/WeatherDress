//
//  Model.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct GeocodeRequest: GeoSerachRequestable {
    let method: HTTPMethod = .get
    let headers: [String : String]? = ["Authorization": "KakaoAK \(Bundle.main.kakaoApiKey)"]
    let function: GeoSearchFunction
    let xCoordinate: Double
    let yCoordinate: Double
    var parameters: [String: String] {
        [
            "x": String(self.xCoordinate),
            "y": String(self.yCoordinate)
        ]
    }
}
