//
//  UltraShortNowcastWeatherComponent.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation

enum UltraShortNowcastWeatherComponent: String, CaseIterable {
    case temperature = "T1H"
    case rainfallForAnHour = "RN1"
    case eastWestWindComponent = "UUU"
    case southNorthWindComponent = "VVV"
    case humidity = "REH"
    case rainfallType = "PTY"
}
