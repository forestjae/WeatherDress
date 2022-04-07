//
//  WeatherDress+Bundle.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

extension Bundle {
    var weatherApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_Weather"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }

    var kakaoApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_Kakao"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
}
