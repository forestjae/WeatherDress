//
//  DefaultWeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    private let apiService: WeatherService
    private let cacheService: WeatherCacheService

    init(apiService: WeatherService) {
        self.apiService = apiService
        self.cacheService = WeatherCacheService.shared
    }

    func fetchCurrentWeather(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<CurrentWeather> {
        let ultraShortNowcast: Observable<UltraShortNowcastWeatherItem>

        if let usnCache = self.cacheService.fetchUltraShortNowcast(for: location, at: date) {
            ultraShortNowcast = Observable.just(usnCache).share()
        } else {
            ultraShortNowcast = self.apiService
                .fetchUltraShortNowcast(for: location, at: date - 40 * 60 - 1)
                .do(onSuccess: {
                    let key = self.cacheService.convertToKey(
                        for: location,
                        date: date,
                        dateFormat: .ultraShortNowcastTime
                    )
                    self.cacheService.ultraShortNowcastCache
                        .setObject(CacheValue($0), forKey: key)
                })
                .asObservable()
        }

        let ultraShortForecast: Observable<UltraShortForecastWeatherList>

        if let usfCache = self.cacheService.fetchUltraShortForecast(for: location, at: date) {
            ultraShortForecast = Observable.just(usfCache).share()
        } else {
            ultraShortForecast = self.apiService
                .fetchUltraShortForecast(for: location, at: date - 45 * 60 - 1)
                .do(onSuccess: {
                    let key = self.cacheService.convertToKey(
                        for: location,
                        date: date,
                        dateFormat: .ultraShortForecastTime
                    )
                    self.cacheService.ultraShortForecastCache
                        .setObject(CacheValue($0), forKey: key)
                })
                .asObservable()
        }

        return Observable.combineLatest(
            ultraShortNowcast,
            ultraShortForecast.compactMap { $0.forecastList.first }
        )
            .map { ultraShortNowcast, ultraShortForecast in
                CurrentWeather(
                    ultraShortNowcast: ultraShortNowcast,
                    ultraShortForecast: ultraShortForecast
                )
            }.asObservable()
    }

    func fetchHourlyWeathers(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<[HourlyWeather]> {
        let ultraShortForecast: Observable<UltraShortForecastWeatherList>
        let shortForecast: Observable<ShortForecastWeatherList>

        if let usfCache = self.cacheService.fetchUltraShortForecast(for: location, at: date) {
            ultraShortForecast = Observable.just(usfCache).share()
        } else {
            ultraShortForecast = self.apiService.fetchUltraShortForecast(
                for: location,
                at: date - 45 * 60 - 1
            )
            .asObservable()
        }

        if let sfCache = self.cacheService.fetchShortForecast(for: location, at: date) {
            shortForecast = Observable.just(sfCache).share()
        } else {
            shortForecast = self.apiService.fetchShortForecast(for: location, at: date - 2 * 3600)
                .asObservable()
        }

        return Observable.combineLatest(
            ultraShortForecast
                .map { $0.forecastList.map { HourlyWeather(ultraShortForecast: $0) } }
            ,
            shortForecast
                .map { $0.forecastList.map { HourlyWeather(shortForecast: $0) } }
        ).map { ustList, stList in
            ustList + stList.filter { !ustList.map { $0.date }.contains($0.date) }
        }.map { $0.sorted { $0.date < $1.date } }
    }

    func fetchDailyWeathers(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<[DailyWeather]> {
        let midWeatherForecast: Observable<[MidForecastWeatherItem]>
        let midTemperatureForecast: Observable<[MidForecastTemperatureItem]>

        if let mwfCache = self.cacheService.fetchMidWeatherForecast(for: location, at: date) {
            midWeatherForecast = Observable.just(mwfCache).share()
        } else {
            midWeatherForecast = self.apiService.fetchMidWeatherForecast(
                for: location, at: date - 3600 * 6 - 1
            )
                .asObservable()
        }

        if let mtfCache = self.cacheService.fetchMidTemperatureForecast(for: location, at: date) {
            midTemperatureForecast = Observable.just(mtfCache).share()
        } else {
            midTemperatureForecast = self.apiService.fetchMidTemperatureForecast(
                for: location, at: date - 3600 * 6 - 1
            )
                .asObservable()
        }
        return Observable.zip(midWeatherForecast, midTemperatureForecast)
            .map { weathers, temperatures in
                zip(weathers, temperatures)
                    .map { weather, temperature in
                        DailyWeather(
                            midWeatherForecast: weather,
                            midTemperatureForecast: temperature
                        )
                    }
            }
    }
}
