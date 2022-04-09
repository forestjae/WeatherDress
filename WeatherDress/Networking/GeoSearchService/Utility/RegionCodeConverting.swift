//
//  RegionCodeConverting.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import UIKit

struct RegionCodeConverting {
    static let shared = RegionCodeConverting()
    private let code = NSDataAsset(name: "WeatherCode")
    private var list: [RegionCodeInfo] = []

    init() {
        let decoder = JSONDecoder()
        if let data = self.code?.data {
            do {
                let decoded = try decoder.decode([RegionCodeInfo].self, from: data)
                self.list = decoded
                } catch let error {
                    print(error)
                }
        }
    }

    func convert(from address: String, to type: CodeType) -> String? {
        let filteredByThird = self.list.filter { address.contains($0.thirdRegion) }

        if let first = filteredByThird.first, filteredByThird.count == 1 {
            return regionCode(from: first, for: type)
        }
        let filteredBySecond = self.list.filter { address.contains($0.secondRegion) }
        if let first = filteredBySecond.first, filteredBySecond.count == 1 {
            return regionCode(from: first, for: type)
        } else {
            let filteredByFirst = filteredBySecond.filter { address.contains($0.firstRegion) }
            if let first = filteredByFirst.first, filteredByFirst.count == 1 {
                return regionCode(from: first, for: type)
            }
        }
        return nil
    }

    private func regionCode(from code: RegionCodeInfo, for type: CodeType) -> String {
        switch type {
        case .weather:
            return code.weatherCode
        case .temperature:
            return code.temperatureCode
        }
    }

    enum CodeType {
        case weather
        case temperature
    }
}

struct RegionCodeInfo: Decodable {
    let firstRegion: String
    let secondRegion: String
    let thirdRegion: String
    let weatherCode: String
    let temperatureCode: String
}
