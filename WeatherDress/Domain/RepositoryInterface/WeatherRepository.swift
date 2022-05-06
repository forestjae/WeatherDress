//
//  WeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift

protocol WeatherRepository {
    func fetchCurrentWeather(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<CurrentWeather>

    func fetchHourlyWeathers(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<[HourlyWeather]>

    func fetchDailyWeathers(
        for location: LocationInfo,
        at date: Date
    ) -> Observable<[DailyWeather]>
}
