//
//  WeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

protocol WeatherRepository {
    func fetch(from location: LocationInfo) -> Observable<UltraShortNowcastWeatherItem?>
    func fetchHourlyWeathers(from location: LocationInfo) -> Observable<[HourlyWeather]>
    func fetchDailyWeathers(from location: LocationInfo) -> Observable<[DailyWeather]>
}
