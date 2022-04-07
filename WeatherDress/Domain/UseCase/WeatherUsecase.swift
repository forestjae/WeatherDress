//
//  WeatherUsecase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

final class WeatherUsecase {
    let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func fetch() -> Observable<UltraShortNowcastWeatherItem?> {
        return self.repository.fetch()
    }

    func fetchHourlWeatehr() -> Observable<[HourlyWeather]> {
        return self.repository.fetchHourlyWeathers()
    }
}
