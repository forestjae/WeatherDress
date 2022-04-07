//
//  DefaultWeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultWeatherRepository: WeatherRepository {
    let apiService: WeatherService
    private let disposeBag = DisposeBag()

    init(apiService: WeatherService) {
        self.apiService = apiService
    }

    func fetch() -> Observable<UltraShortNowcastWeatherItem?> {
        return self.apiService.fetchUltraShortNowcastWeather(xAxisNumber: 61, yAxisNumber: 121).asObservable()
    }

    func fetchHourlyWeathers() -> Observable<[HourlyWeather]> {
        return self.apiService.fetchUltraShortForecastWeather(xAxisNumber: 61, yAxisNumber: 121)
            .map { $0.forecastList.map { item in
                return HourlyWeather(date: item.forecastDate, skyCondition: item.skyCondition.rawValue, temperature: Int(item.temperature))
            } }
            .map { $0.sorted { $0.date < $1.date }
            }
            .asObservable()
    }
}
