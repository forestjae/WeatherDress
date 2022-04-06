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
    private let weather = BehaviorRelay<UltraShortNowcastWeatherItem?>(value: nil)
    private let disposeBag = DisposeBag()

    init(apiService: WeatherService) {
        self.apiService = apiService
    }

    func fetch() -> Observable<UltraShortNowcastWeatherItem?> {
        return self.weather.asObservable()
    }

    func fetchUltraShortNowcastWeather() {
        self.apiService.fetchUltraShortNowcastWeather(xAxisNumber: 61, yAxisNumber: 121)
            .subscribe(onSuccess: { emmiter in
                self.weather.accept(emmiter)
            })
            .disposed(by: self.disposeBag)
    }
}
