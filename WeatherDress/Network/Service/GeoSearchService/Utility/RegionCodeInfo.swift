//
//  RegionCodeInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/20.
//

import Foundation

struct RegionCodeInfo: Decodable {
    let firstRegion: String
    let secondRegion: String
    let thirdRegion: String
    let weatherCode: String
    let temperatureCode: String
}
