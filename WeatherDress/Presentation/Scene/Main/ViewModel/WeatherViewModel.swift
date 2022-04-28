//
//  WeatherViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RxSwift

final class WeatherViewModel {

    private let disposeBag = DisposeBag()
    private let useCase: WeatherUseCase
    private let locationInfo: BehaviorSubject<LocationInfo>

    init(useCase: WeatherUseCase, location: LocationInfo) {
        self.useCase = useCase
        let locationInfo = BehaviorSubject<LocationInfo>(value: location)
        self.locationInfo = locationInfo
    }

    struct Input {
        let viewWillAppear: Observable<Void>
    }

    struct Output {
        // currentWeather
        let hourlyWeathers: Observable<[HourlyWeather]>
        let dailyWeather: Observable<[DailyWeather]>
        let location: Observable<LocationInfo>
        //let locationLabelText: Observable<String>
        //let currentWeatherImageName: Observable<String>
        let currentTemperatureLabelText: Observable<String>
        let currentWeatherCondition: Observable<WeatherCondition>
//        let currentWeatherConditionLabelText: Observable<String>
//        let currentWeatherDescriptionLabelText: Observable<String>
//        let currentMinMaxTemperatureLabelText: Observable<(String, String)>
    }

    func setLocationInfo(_ location: LocationInfo) {
        self.locationInfo.onNext(location)
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {

        let hourlyWeathers = locationInfo
            .flatMap {
                self.useCase.fetchHourlWeatehr(from: $0)
            }
            .do(onError: { error in
                print("에러발생!!!")
            })

        let dailyWeathers = locationInfo
            .flatMap {
                self.useCase.fetchDailyWeather(from: $0)
            }

        let currentWeather = locationInfo
            .flatMap {
                self.useCase.fetch(from: $0)
            }

        let currentTemperatureLabelText = currentWeather
            .compactMap { $0 }
            .compactMap { String(Int($0.temperature.rounded())) }

        let currentWeatherCondition = hourlyWeathers
            .compactMap { $0.first?.weatherCondition }

        return Output(
            hourlyWeathers: hourlyWeathers,
            dailyWeather: dailyWeathers,
            location: self.locationInfo.asObservable(),
            currentTemperatureLabelText: currentTemperatureLabelText,
            currentWeatherCondition: currentWeatherCondition
        )
    }
}
