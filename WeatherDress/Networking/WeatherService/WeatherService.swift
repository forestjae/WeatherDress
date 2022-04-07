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
    ) -> Single<UltraShortNowcastWeatherItem?> {
        return Single.create { single in
            let request = ShortForecastRequest(
                function: .ultraShortNowcast,
                xAxisNumber: xAxisNumber,
                yAxisNumber: yAxisNumber,
                serviceKey: self.serviceKey
            )

            self.apiProvider.request(request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(UltraShortNowcastWeatherResponse.self, from: data) else { return }
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
                xAxisNumber: xAxisNumber,
                yAxisNumber: yAxisNumber,
                serviceKey: self.serviceKey
            )
            self.apiProvider.request(request) { result in
                print("통신 완료")
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let decoded = try? decoder.decode(
                        UltraShortForecastWeatherResponse.self,
                        from: data
                    ) else {
                        print("통신 에러")
                        return
                    }
                    let weaterComponents = decoded.response.body.items.item
                    let resultWeather = UltraShortForecastWeatherList(items: weaterComponents)
                    print(resultWeather.forecastList.count)
                    single(.success(resultWeather))
                case .failure(let error):
                    print("Error!!!!!!!!!!!!!!: \(error)")
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
