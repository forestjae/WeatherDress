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

    func fetchUltraShortNowcastWeather(
        xAxisNumber: Int,
        yAxisNumber: Int
    ) -> Single<UltraShortNowcastWeatherItem> {
        return Single.create { single in
            let request = ShortForecastRequest(
                function: .ultraShortNowcast,
                baseDate: Date() - 40 * 60 - 1,
                xAxisNumber: xAxisNumber,
                yAxisNumber: yAxisNumber,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(
                        UltraShortNowcastWeatherResponse.self,
                        from: data
                    ) else {
                        return
                    }
                    let weaterComponents = decoded.response.body?.items.item ?? []
                    guard let resultWeather = UltraShortNowcastWeatherItem(items: weaterComponents) else {
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

    func fetchUltraShortForecastWeather(
        xAxisNumber: Int,
        yAxisNumber: Int
    ) -> Single<UltraShortForecastWeatherList> {
        return Single.create { single in
            let request = ShortForecastRequest(
                function: .ultraShortForecast,
                baseDate: Date() - 45 * 60 - 1,
                xAxisNumber: xAxisNumber,
                yAxisNumber: yAxisNumber,
                serviceKey: self.serviceKey
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(
                        UltraShortForecastWeatherResponse.self,
                        from: data
                    ) else {
                        return
                    }
                    let weaterComponents = decoded.response.body.items.item
                    let resultWeather = UltraShortForecastWeatherList(items: weaterComponents)
                    single(.success(resultWeather))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func fetchShortForecastWeather(
        xAxisNumber: Int,
        yAxisNumber: Int
    ) -> Single<ShortForecastWeatherList> {
        print("Short:\(Date())")
        return Single.create { single in
            let request = ShortForecastRequest(
                function: .shortForecast,
                baseDate: Date() - 2 * 3600,
                xAxisNumber: xAxisNumber,
                yAxisNumber: yAxisNumber,
                serviceKey: self.serviceKey
            )
            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(
                        ShortForecastWeatherResponse.self,
                        from: data
                    ) else {
                        return
                    }
                    let weaterComponents = decoded.response.body.items.item
                    let resultWeather = ShortForecastWeatherList(items: weaterComponents)
                    single(.success(resultWeather))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func fetchMidForecastWeather(regionCode: String) -> Single<[MidForecastWeatherItem]> {
        return Single.create { single in
            let request = MidForecastRequest(
                function: .midLandForecast,
                regionIdentification: regionCode,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(MidForecastWeatherResponse.self, from: data) else {
                        return
                    }
                    guard let item = decoded.response.body.items.item.first else {
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

    func fetchMidForecastTemperature(regionCode: String) -> Single<[MidForecastTemperatureItem]> {
        return Single.create { single in
            let request = MidForecastRequest(
                function: .midTemperatureForecast,
                regionIdentification: regionCode,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(MidForecastTemperatureResponse.self, from: data) else {
                        return
                    }
                    guard let item = decoded.response.body.items.item.first else {
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
