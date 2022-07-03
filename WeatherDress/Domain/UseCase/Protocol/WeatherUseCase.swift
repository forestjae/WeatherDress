//
//  WeatherUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/07/03.
//

import Foundation
import RxSwift

protocol WeatherUseCase {
    func fetchCurrentWeather(from location: LocationInfo) -> Observable<CurrentWeather>
    func fetchHourlyWeather(from location: LocationInfo) -> Observable<[HourlyWeather]>
    func fetchDailyWeather(from location: LocationInfo) -> Observable<[DailyWeather]>
}
