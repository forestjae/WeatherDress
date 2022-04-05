//
//  WeatherDress+Bundle.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String
        else {
            fatalError("API키가 없습니다.")
        }

        return key
    }
}
