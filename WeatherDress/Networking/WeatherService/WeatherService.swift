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
    let serviceKey = Bundle.main.apiKey

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
                case .failure:
                    print("error")
                }
            }
            return Disposables.create()
        }
    }
}
