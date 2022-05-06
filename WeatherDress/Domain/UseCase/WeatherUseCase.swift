//
//  WeatherUsecase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

final class WeatherUseCase {
    let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func fetchCurrentWeather(from location: LocationInfo) -> Observable<CurrentWeather> {
        return self.repository.fetchCurrentWeather(for: location, at: Date())
    }

    func fetchHourlWeatehr(from location: LocationInfo) -> Observable<[HourlyWeather]> {
        return self.repository.fetchHourlyWeathers(for: location, at: Date())
    }

    func fetchDailyWeather(from location: LocationInfo) -> Observable<[DailyWeather]> {
        return self.repository.fetchDailyWeathers(for: location, at: Date())
    }
}
