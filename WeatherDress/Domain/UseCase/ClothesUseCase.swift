//
//  ClothesUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/11.
//

import Foundation
import RxSwift

class ClothesUseCase {

    let repository: ClothesRepository

    init(repository: ClothesRepository) {
        self.repository = repository
    }

    func fetchCurrentRecommendedCloting(
        for hourlyWeathers: [HourlyWeather]
    ) -> Observable<[Clothes]> {
        let temperatures = hourlyWeathers.map { $0.temperature }
        guard let maxTemperature = temperatures.max(),
              let minTemperature = temperatures.min() else {
                  return Observable.error(ClothesUseCaseError.wrongTemperature)
              }

        return self.repository.fetchCurrentRecommendedCloting(for: minTemperature...maxTemperature)
    }
}

enum ClothesUseCaseError: Error {
    case wrongTemperature
}
