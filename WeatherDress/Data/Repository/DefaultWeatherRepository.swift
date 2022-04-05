//
//  DefaultWeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    let apiService: WeatherService

    init(apiService: WeatherService) {
        self.apiService = apiService
    }

    func fetchUltraShortNowcastWeather() -> Single<UltraShortNowcastWeatherItem> {
        self.apiService.fetchUltraShortNowcastWeather(xAxisNumber: 61, yAxisNumber: 121)
    }
}
