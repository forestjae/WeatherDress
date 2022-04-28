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

    func fetch(from location: LocationInfo) -> Observable<UltraShortNowcastWeatherItem?> {
        return self.repository.fetch(from: location)
    }

    func fetchHourlWeatehr(from location: LocationInfo) -> Observable<[HourlyWeather]> {
        return self.repository.fetchHourlyWeathers(from: location)
    }

    func fetchDailyWeather(from location: LocationInfo) -> Observable<[DailyWeather]> {
        return self.repository.fetchDailyWeathers(from: location)
    }
}
