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

    func fetchCurrentWeather(from location: LocationInfo) -> Observable<CurrentWeather> {
        return Observable.combineLatest(
            self.apiService.fetchUltraShortNowcast(for: location).asObservable(),
            self.apiService.fetchUltraShortForecast(for: location)
                .compactMap { $0.forecastList.first }.asObservable()
        )
            .map { ultraShortNowcast, ultraShortForecast in
                CurrentWeather(
                    ultraShortNowcast: ultraShortNowcast,
                    ultraShortForecast: ultraShortForecast
                )
            }.asObservable()
    }

    func fetchHourlyWeathers(from location: LocationInfo) -> Observable<[HourlyWeather]> {
        return Observable.combineLatest(
            self.apiService.fetchUltraShortForecast(for: location)
                .map { $0.forecastList.map { HourlyWeather(ultraShortForecast: $0) } }
                .asObservable(),
            self.apiService.fetchShortForecast(for: location)
                .map { $0.forecastList.map { HourlyWeather(shortForecast: $0) } }
                .asObservable()
        ).map { ustList, stList in
            ustList + stList.filter { !ustList.map { $0.date }.contains($0.date) }
        }.map { $0.sorted { $0.date < $1.date } }
    }

    func fetchDailyWeathers(from location: LocationInfo) -> Observable<[DailyWeather]> {
        return Observable.zip(
            self.apiService.fetchMidWeatherForecast(for: location).asObservable(),
            self.apiService.fetchMidTemperatureForecast(for: location).asObservable())
            .map { weather, temperature in
                zip(weather, temperature)
                    .map { weather, temperature in
                        DailyWeather(
                            midWeatherForecast: weather,
                            midTemperatureForecast: temperature
                        )
                    }
            }
    }
}
