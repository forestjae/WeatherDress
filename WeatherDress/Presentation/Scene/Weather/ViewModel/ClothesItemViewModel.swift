//
//  ClothesItemViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/15.
//

import Foundation

struct ClothesItemViewModel: Hashable {
    let type: ClothesType
    let name: String

    init(_ clothes: Clothes) {
        self.type = clothes.type
        self.name = clothes.name
    }
}
