//
//  ClothesType.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/10.
//

import Foundation

enum ClothesType: String, Decodable, CaseIterable {
    case outer
    case top
    case bottoms
    case accessory

    var description: String {
        switch self {
        case .outer:
            return "아우터"
        case .top:
            return "상의"
        case .bottoms:
            return "하의"
        case .accessory:
            return "etc"
        }
    }
}
