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
            .map { $0.filter { $0.date > Date() - 3600 }}

        let dailyWeathers = locationInfo
            .flatMap {
                self.useCase.fetchDailyWeather(from: $0)
            }

        let dailWeathersConverted = Observable.zip(hourlyWeathers, dailyWeathers)
            .map { hourly, dailyWeathers -> [DailyWeather] in
                let today = Calendar.current.dateComponents([.day], from: Date()).day
                let tommorrow = Calendar.current.dateComponents([.day], from: Date() + 3600 * 24).day
                let theDayAfterTommorrow = Calendar.current.dateComponents([.day], from: Date() + 3600 * 48).day

                let todayItems = hourly.filter { Calendar.current.dateComponents([.day], from: $0.date).day == today }
                let tommorowItems = hourly.filter { Calendar.current.dateComponents([.day], from: $0.date).day == tommorrow }
                let theDayAfterTommorrowItems = hourly.filter { Calendar.current.dateComponents([.day], from: $0.date).day == theDayAfterTommorrow }
                let itemsSet = [todayItems, tommorowItems, theDayAfterTommorrowItems]
                let dailyConverted = itemsSet.map { items -> DailyWeather in
                    let temperatureList = items.map { $0.temperature }
                    let maxTemp = temperatureList.max()!
                    let minTemp = temperatureList.min()!
                    return DailyWeather(date: items.first!.date, weatherCondition: .clear, rainfallProbability: 0, maximumTemperature: maxTemp, minimunTemperature: minTemp)
                }

                return dailyConverted + dailyWeathers
            }

        let currentTemperatureLabelText = currentWeather
            .compactMap { $0 }
            .compactMap { String(Int($0.temperature.rounded())) }

        let currentWeatherCondition = hourlyWeathers
            .compactMap { $0.first?.weatherCondition }

        return Output(
            hourlyWeathers: hourlyWeathers,
            dailyWeather: dailWeathersConverted,
            location: self.locationInfo.asObservable(),
            currentTemperatureLabelText: currentTemperatureLabelText,
            currentWeatherCondition: currentWeatherCondition
        )
    }
}
