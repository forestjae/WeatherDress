//
//  ClothesItemViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/15.
//

import Foundation

struct ClothesItemViewModel: Hashable {
    let type: ClothesType
    let name: String?
    var discription: String {
        switch self.type {
        case .outer:
            return "아우터가 필요없는 따뜻한 날씨에요"
        case .accessory:
            return "추천 악세사리가 없어요"
        default:
            return "추천 아이템이 없어요"
        }
    }

    init(_ clothes: Clothes) {
        self.type = clothes.type
        self.name = clothes.name
    }

    init(type: ClothesType) {
        self.type = type
        self.name = nil
    }
}
