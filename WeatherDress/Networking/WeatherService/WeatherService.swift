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
        for location: LocationInfo
    ) -> Single<UltraShortNowcastWeatherItem> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = UltraShortNowcastRequest(
                baseDate: Date() - 40 * 60 - 1,
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
    }

    func fetchUltraShortForecast(
        for location: LocationInfo
    ) -> Single<UltraShortForecastWeatherList> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = UltraShortForecastRequest(
                baseDate: Date() - 45 * 60 - 1,
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
    }

    func fetchShortForecast(for location: LocationInfo) -> Single<ShortForecastWeatherList> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return Single.create { single in
            let request = ShortForecastRequest(
                baseDate: Date() - 2 * 3600,
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
    }

    func fetchMidWeatherForecast(for location: LocationInfo) -> Single<[MidForecastWeatherItem]> {
        let address = location.address.fullAddress
        let weatherCode = RegionCodeConverting.shared.convert(from: address, to: .weather) ?? ""
        return Single.create { single in
            let request = MidWeatherForecastRequest(
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
    }

    func fetchMidTemperatureForecast(for location: LocationInfo) -> Single<[MidForecastTemperatureItem]> {
        let address = location.address.fullAddress
        let temperatureCode = RegionCodeConverting.shared.convert(from: address, to: .temperature) ?? ""
        return Single.create { single in
            let request = MidTemperatureForecastRequest(
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
    }
}
