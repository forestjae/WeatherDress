//
//  WeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

protocol WeatherRepository {
    func fetchUltraShortNowcastWeather() -> Single<UltraShortNowcastWeatherItem>
}
