//
//  DefaultClothesRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/15.
//

import Foundation
import UIKit
import RxSwift

final class DefaultClothesRepository: ClothesRepository {
    let clothes: [Clothes]

    init() {
        if let data = NSDataAsset(name: "Clothes")?.data,
           let decoded = try? JSONDecoder().decode([Clothes].self, from: data) {
            self.clothes = decoded
        } else {
            self.clothes = []
        }
    }

    func fetchCurrentRecommendedClothing(
        for range: ClosedRange<Double>,
        in gender: Gender
    ) -> Observable<[Clothes]> {
        let filteredByTemperature = self.clothes.filter { clothes in
            range.overlaps(clothes.temperatureRange)
        }
        let filteredByGender = filteredByTemperature.filter {
            $0.gender == gender || $0.gender == .unisex
        }

        return Observable.just(filteredByGender)
    }
}
