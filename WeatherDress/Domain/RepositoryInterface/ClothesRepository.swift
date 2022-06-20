//
//  ClothesRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/11.
//

import Foundation
import RxSwift

protocol ClothesRepository {
    func fetchCurrentRecommendedClothing(
        for range: ClosedRange<Double>,
        in gender: Gender
    ) -> Observable<[Clothes]>
}
