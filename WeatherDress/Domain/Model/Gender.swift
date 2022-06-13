//
//  Gender.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/10.
//

import Foundation

enum Gender: String, Decodable {
    case male
    case female
    case unisex

    var description: String {
        switch self {
        case .male:
            return "남"
        case .female:
            return "여"
        case .unisex:
            return "혼성"
        }
    }
}

extension Gender {
    init?(index: Int) {
        switch index {
        case 0:
            self = .male
        case 1:
            self = .female
        default:
            return nil
        }
    }

    var index: Int? {
        switch self {
        case .male:
            return 0
        case .female:
            return 1
        case .unisex:
            return nil
        }
    }
}
