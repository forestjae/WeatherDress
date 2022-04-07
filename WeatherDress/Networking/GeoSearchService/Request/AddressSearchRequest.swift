//
//  Model.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct AddressSearchRequest: GeoSerachRequestable {
    let method: HTTPMethod = .get
    let headers: [String : String]? = ["Authorization": "KakaoAK \(Bundle.main.kakaoApiKey)"]
    let function: GeoSearchFunction
    let query: String
    let page: Int = 1
    let size: Int = 30
    var parameters: [String: String] {
        [
            "query": self.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
            "page": String(self.page),
            "size": String(self.size)
        ]
    }
}

