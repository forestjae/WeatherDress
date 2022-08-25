//
//  ClothesUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/07/05.
//

import Foundation
import RxSwift

protocol ClothesUseCase {
    func fetchCurrentRecommendedCloting(
        for hourlyWeathers: [HourlyWeather],
        in gender: Gender,
        leaveTime: Date,
        returnTime: Date,
        temperatureSensitiveness: TemperatureSensitiveness
    ) -> Observable<[Clothes]>
}
