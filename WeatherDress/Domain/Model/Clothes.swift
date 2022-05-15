//
//  Clothes.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/10.
//

import Foundation

struct Clothes: Equatable, Decodable {
    let type: ClothesType
    let name: String
    let gender: Gender
    let maxTemperature: Double
    let minTemperature: Double
}

extension Clothes {
    var temperatureRange: ClosedRange<Double> {
        return minTemperature...maxTemperature
    }
}
