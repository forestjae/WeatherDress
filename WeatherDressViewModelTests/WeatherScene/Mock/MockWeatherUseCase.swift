//
//  MockWeatherUseCase.swift
//  WeatherDressViewModelTests
//
//  Created by Lee Seung-Jae on 2022/07/03.
//

import Foundation
import RxSwift

class MockWeatherUseCase: WeatherUseCase {
    let dummyCurrentWeather = CurrentWeather(
        temperature: 24.6,
        weatherCondition: .clear,
        rainfallForAnHour: 0.0,
        rainfallType: .none,
        humidity: 100.0
    )

    let dummyHourlyWeathers = Array<Int>(0...72).map { HourlyWeather(
        date: Date() + TimeInterval($0 * 3600 * 24),
        weatherCondition: .clear,
        temperature: .random(in: 20...30)
    )}

    let dummyDailyWeathers = Array<Int>(3...10).map { DailyWeather(
        date: Date() + TimeInterval($0 * 3600 * 24),
        weatherCondition: .clear,
        rainfallProbability: .random(in: 0...30),
        maximumTemperature: .random(in: 26...30),
        minimunTemperature: .random(in: 20...25)
    )}

    func fetchCurrentWeather(from location: LocationInfo) -> Observable<CurrentWeather> {
        return Observable<CurrentWeather>.just(self.dummyCurrentWeather)
    }

    func fetchHourlyWeather(from location: LocationInfo) -> Observable<[HourlyWeather]> {
        return Observable<[HourlyWeather]>.just(self.dummyHourlyWeathers)
    }

    func fetchDailyWeather(from location: LocationInfo) -> Observable<[DailyWeather]> {
        return Observable<[DailyWeather]>.just(self.dummyDailyWeathers)
    }
}
