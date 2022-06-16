//
//  WeatherService.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

final class WeatherService {
    let apiProvider: APIProvider
    let serviceKey = Bundle.main.weatherApiKey

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }

    func fetchUltraShortNowcast(
        for location: LocationInfo,
        at date: Date
    ) -> Single<UltraShortNowcastWeatherItem> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = UltraShortNowcastRequest(
                baseDate: date,
                xAxisNumber: converted.xGrid,
                yAxisNumber: converted.yGRid,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    guard let weaterComponents = response.response.body?.items.item,
                          let resultWeather = UltraShortNowcastWeatherItem(
                            items: weaterComponents
                          ) else {
                              return
                          }
                    single(.success(resultWeather))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .timeout(.milliseconds(3000), scheduler: MainScheduler.instance)
    }

    func fetchUltraShortForecast(
        for location: LocationInfo,
        at date: Date
    ) -> Single<UltraShortForecastWeatherList> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = UltraShortForecastRequest(
                baseDate: date,
                xAxisNumber: converted.xGrid,
                yAxisNumber: converted.yGRid,
                serviceKey: self.serviceKey
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    let weaterComponents = response.response.body.items.item
                    let resultWeather = UltraShortForecastWeatherList(items: weaterComponents)
                    single(.success(resultWeather))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .timeout(.milliseconds(3000), scheduler: MainScheduler.instance)
    }

    func fetchShortForecast(
        for location: LocationInfo,
        at date: Date
    ) -> Single<ShortForecastWeatherList> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = ShortForecastRequest(
                baseDate: date,
                xAxisNumber: converted.xGrid,
                yAxisNumber: converted.yGRid,
                serviceKey: self.serviceKey
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    let weaterComponents = response.response.body.items.item
                    let resultWeather = ShortForecastWeatherList(items: weaterComponents)
                    single(.success(resultWeather))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .timeout(.milliseconds(3000), scheduler: MainScheduler.instance)
    }

    func fetchMidWeatherForecast(
        for location: LocationInfo,
        at date: Date
    ) -> Single<[MidForecastWeatherItem]> {
        let address = location.address.fullAddress
        let weatherCode = RegionCodeConverting.shared.convert(from: address, to: .weather) ?? ""
        return Single.create { single in
            let request = MidWeatherForecastRequest(
                baseDate: date,
                regionIdentification: weatherCode,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    guard let item = response.response.body.items.item.first else {
                        return
                    }

                    let result = MidForecastWeaherItemList(response: item)
                    single(.success(result.items))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .timeout(.milliseconds(3000), scheduler: MainScheduler.instance)
    }

    func fetchMidTemperatureForecast(
        for location: LocationInfo,
        at date: Date
    ) -> Single<[MidForecastTemperatureItem]> {
        let address = location.address.fullAddress
        let temperatureCode = RegionCodeConverting.shared.convert(from: address, to: .temperature) ?? ""
        return Single.create { single in
            let request = MidTemperatureForecastRequest(
                baseDate: date,
                regionIdentification: temperatureCode,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let response):
                    guard let item = response.response.body.items.item.first else {
                        return
                    }
                    let result = MidForecastTemperatureItemList(response: item)
                    single(.success(result.items))

                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .timeout(.milliseconds(3000), scheduler: MainScheduler.instance)
    }
}
