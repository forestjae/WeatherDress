//
//  ClothesUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/11.
//

import Foundation
import RxSwift

final class DefaultClothesUseCase: ClothesUseCase {
    let repository: ClothesRepository

    init(repository: ClothesRepository) {
        self.repository = repository
    }

    func fetchCurrentRecommendedCloting(
        for hourlyWeathers: [HourlyWeather],
        in gender: Gender,
        leaveTime: Date,
        returnTime: Date,
        temperatureSensitiveness: TemperatureSensitiveness
    ) -> Observable<[Clothes]> {
        let temperatures = hourlyWeathers
            .filter {
                leaveTime <= $0.date && returnTime >= $0.date
            }
            .map { $0.temperature }
        
        guard let maxTemperature = temperatures.max(),
              let minTemperature = temperatures.min() else {
                  return Observable.error(ClothesUseCaseError.wrongTemperature)
              }

        let revisedMaxTemperature = maxTemperature + temperatureSensitiveness.temperatureToRevise
        let revisedMinTemperature = minTemperature + temperatureSensitiveness.temperatureToRevise

        return self.repository.fetchCurrentRecommendedClothing(
            for: revisedMinTemperature...revisedMaxTemperature,
            in: gender
        )
    }
}

enum ClothesUseCaseError: Error {
    case wrongTemperature
}
