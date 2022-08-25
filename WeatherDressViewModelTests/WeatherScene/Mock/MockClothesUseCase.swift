//
//  MockClothesUseCase.swift
//  WeatherDressViewModelTests
//
//  Created by Lee Seung-Jae on 2022/07/05.
//

import Foundation
import RxSwift

class MockClothesUseCase: ClothesUseCase {
    func fetchCurrentRecommendedCloting(
        for hourlyWeathers: [HourlyWeather],
        in gender: Gender,
        leaveTime: Date,
        returnTime: Date,
        temperatureSensitiveness: TemperatureSensitiveness
    ) -> Observable<[Clothes]> {
        return Observable.just([Clothes(type: .top, name: "dd", gender: .male, maxTemperature: 10, minTemperature: 20)])
    }
}
