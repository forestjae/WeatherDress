//
//  MockClothesRepository.swift
//  WeatherDressUseCaseTests
//
//  Created by Lee Seung-Jae on 2022/05/12.
//

import Foundation
import RxSwift

class MockClothesRepository: ClothesRepository {

    func fetchCurrentRecommendedClothing(for range: ClosedRange<Double>) -> Observable<[Clothes]> {
        let data = NSDataAsset(name: "Clothes")?.data
        do {
            let decoded = try JSONDecoder().decode([Clothes].self, from: data!)
            return Observable.just(decoded)
        } catch let error {
            return Observable.just([])
        }
    }
}
