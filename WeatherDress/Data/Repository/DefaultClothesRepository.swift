//
//  DefaultClothesRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/15.
//

import Foundation
import UIKit
import RxSwift

class DefaultClothesRepository: ClothesRepository {

    let clothes: [Clothes]

    init() {
        if let data = NSDataAsset(name: "Clothes")?.data,
           let decoded = try? JSONDecoder().decode([Clothes].self, from: data) {
            self.clothes = decoded
        } else {
            self.clothes = []
        }
    }

    func fetchCurrentRecommendedClothing(for range: ClosedRange<Double>) -> Observable<[Clothes]> {
        let filtered = self.clothes.filter { clothes in
            clothes.temperatureRange ~= range
        }
        return Observable.just(filtered)
    }
}
