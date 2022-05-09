//
//  WeatherViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RxSwift
import RxCocoa

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
        let locationAddress: Driver<String>
        let isCurrentLocation: Driver<Bool>
        let currentTemperatureLabelText: Driver<String>
        let currentWeatherConditionImageURL: Observable<(String, CurrentWeatherImageView.ImageType)>
        let currentWeatherCondition: Driver<String>
        let minMaxTemperature: Driver<String>
        let hourlyWeatherItem: Driver<[HourlyWeatherItemViewModel]>
        let dailyWeatherItem: Driver<[DailyWeatherItemViewModel]>
    }

    func setLocationInfo(_ location: LocationInfo) {
        self.locationInfo.onNext(location)
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locationAddress = self.locationInfo
            .map { $0.shortAddress() }
            .asDriver(onErrorJustReturn: "위치 정보가 없습니다")

        let isCurrentLocation = self.locationInfo
            .map { $0.isCurrent }
            .asDriver(onErrorJustReturn: false)

        let currentWeather = self.locationInfo
            .withUnretained(self)
            .flatMap { viewModel, locationInfo in
                viewModel.useCase.fetchCurrentWeather(from: locationInfo)
            }
            .share()

        let hourlyWeathers = self.locationInfo
            .withUnretained(self)
            .flatMap { viewModel, locationInfo in
                self.useCase.fetchHourlWeatehr(from: locationInfo)
            }
            .share()

        let dailyWeathers = locationInfo
            .withUnretained(self)
            .flatMap { viewModel, locationInfo in
                viewModel.useCase.fetchDailyWeather(from: locationInfo)
            }
            .share()

        let currentTemperatureLabelText = currentWeather
            .map { " " + $0.temperature.celsiusExpression }
            .asDriver(onErrorJustReturn: "--")

        let currentWeatherCondition = currentWeather
            .map { $0.weatherCondition.rawValue }
            .asDriver(onErrorJustReturn: "-")

        let currentWeatherConditionImageURL = currentWeather
            .map { currentWeather -> (String, CurrentWeatherImageView.ImageType) in
                if let url = currentWeather.weatherCondition.animatedImageURL {
                    return (url, .animation)
                } else {
                    return (currentWeather.weatherCondition.staticImageURL, .staticImage)
                }
            }

        let hourlyWeatherItemViewModel = Observable.combineLatest(currentWeather, hourlyWeathers)
            .map { currentWeather, hourlyWeathers in
                [HourlyWeather(currentWeather: currentWeather)] + hourlyWeathers
                    .filter { $0.date > Date() }
            }
            .map {
                $0.enumerated().map { index, weather in
                    HourlyWeatherItemViewModel(hourlyWeather: weather, index: index)
                }
            }
            .asDriver(onErrorJustReturn: [])

        let dailWeathersFromHourly = hourlyWeathers
            .map { $0.toDaily() }

        let dailyWeatherItemViewModel = Observable.zip(dailWeathersFromHourly, dailyWeathers)
            .map {
                ($0.0 + $0.1).enumerated().map { index, dailyWeather in
                    DailyWeatherItemViewModel(dailyWeather: dailyWeather, index: index)
                }
            }
            .asDriver(onErrorJustReturn: [])

        let minMaxTemperature = dailWeathersFromHourly
            .compactMap { $0.first }
            .map {
                ($0.minimunTemperature, $0.maximumTemperature)
            }
            .map { min, max in
                "최고 \(max.celsiusExpression) / 최저 \(min.celsiusExpression)"
            }
            .asDriver(onErrorJustReturn: "- / -")

        return Output(
            locationAddress: locationAddress,
            isCurrentLocation: isCurrentLocation,
            currentTemperatureLabelText: currentTemperatureLabelText,
            currentWeatherConditionImageURL: currentWeatherConditionImageURL,
            currentWeatherCondition: currentWeatherCondition,
            minMaxTemperature: minMaxTemperature,
            hourlyWeatherItem: hourlyWeatherItemViewModel,
            dailyWeatherItem: dailyWeatherItemViewModel
        )
    }
}
