//
//  Clothes.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/10.
//

import Foundation

struct Clothes {
    let type: ClothesType
    let name: String
    let gender: Gender
    let upperTemperature: Double
    let lowerTemperature: Double

    var temperatureRange: ClosedRange<Double> {
        return lowerTemperature...upperTemperature
    }
}
