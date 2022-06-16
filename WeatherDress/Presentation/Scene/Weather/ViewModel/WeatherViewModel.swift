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

    private let coordinator: WeatherCoordinator
    private let useCase: WeatherUseCase
    private let clothingUseCase: ClothesUseCase
    private let userSettingUseCase: UserSetttingUseCase
    private let locationInfo: BehaviorSubject<LocationInfo>

    init(coordinator: WeatherCoordinator,
         useCase: WeatherUseCase,
         clothingUseCase: ClothesUseCase,
         location: LocationInfo
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.clothingUseCase = clothingUseCase
        self.userSettingUseCase = UserSetttingUseCase(repository: DefaultUserSettingRepository())
        let locationInfo = BehaviorSubject<LocationInfo>(value: location)
        self.locationInfo = locationInfo
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let randomButtonTapped: Observable<Void>
        let allClotingButtonTapped: Observable<Void>
        let timeConfigurationButtonTapped: Observable<Void>
        let timeSliderLowerValueChanged: Observable<Double>
        let timeSliderUpperValueChnaged: Observable<Double>
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
        let allClotingItem: Observable<[ClothesItemViewModel]>
        let recommendedClotingItem: Driver<[ClothesItemViewModel]>
        let leaveReturnTitleText: Observable<String>
        let allClothingViewDismiss: Observable<Void>
        let initialLeaveTime: Observable<Double>
        let initialReturnTIme: Observable<Double>
    }

    func setLocationInfo(_ location: LocationInfo) {
        self.locationInfo.onNext(location)
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let initialLeaveTimeString = input.viewWillAppear
            .take(1)
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.userSettingUseCase.getUserLeaveTime()
            }
            .compactMap { $0 }
            .share()

        let initialLeaveTime = initialLeaveTimeString
            .compactMap { $0.convertToDate() }

        let initialLeaveTimeSliderVlaue = initialLeaveTimeString
            .compactMap { string -> Double? in
                guard let value = Double(String(string.prefix(2))) else {
                    return nil
                }
                return value > 4.0 ? value : value + 24.0
            }

        let initialReturnTimeString = input.viewWillAppear
            .take(1)
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.userSettingUseCase.getUserReturnTime()
            }
            .compactMap { $0 }
            .share()

        let initialReturnTime = initialReturnTimeString
            .compactMap { $0.convertToDate() }

        let initialReturnTimeSliderValue = initialReturnTimeString
            .compactMap { string -> Double? in
                guard let value = Double(String(string.prefix(2))) else {
                    return nil
                }
                return value > 4.0 ? value : value + 24.0
            }

        let leaveTimeConfigured = input.timeSliderLowerValueChanged
            .map { Int($0.rounded(.toNearestOrAwayFromZero)) }
            .map { $0 > 23 ? $0 - 24 : $0 }
            .map { $0.convertToFourDigit() }
            .compactMap { $0.convertToDate() }

        let returnTimeConfigured = input.timeSliderUpperValueChnaged
            .map { Int($0.rounded(.toNearestOrAwayFromZero)) }
            .map { $0 > 23 ? $0 - 24 : $0 }
            .map { $0.convertToFourDigit() }
            .compactMap { $0.convertToDate() }

        let locationAddress = self.locationInfo
            .map { $0.shortAddress() }
            .asDriver(onErrorJustReturn: "서비스가 불가능한 지역입니다.")

        let isCurrentLocation = self.locationInfo
            .map { $0.isCurrent }
            .asDriver(onErrorJustReturn: false)
        
        let currentWeather = self.locationInfo
            .filter { $0.address.firstRegion != "" }
            .withUnretained(self)
            .flatMap { viewModel, locationInfo in
                viewModel.useCase.fetchCurrentWeather(from: locationInfo)
            }
            .share()

        let hourlyWeathers = self.locationInfo
            .withUnretained(self)
            .flatMap { viewModel, locationInfo in
                viewModel.useCase.fetchHourlWeatehr(from: locationInfo)
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

        let leaveTime = Observable.merge(initialLeaveTime, leaveTimeConfigured)
            .distinctUntilChanged()
            .share()

        let returnTime = Observable.merge(initialReturnTime, returnTimeConfigured)
            .distinctUntilChanged()
            .share()

        let userGender = self.userSettingUseCase.getUserGender()
            .compactMap { $0 }

        let userTemperatureSensitiveness = self.userSettingUseCase.getUserTemperatureSensitive()
            .compactMap { $0 }

        let hourlyWeatherItem = Observable.combineLatest(currentWeather, hourlyWeathers)
            .map { currentWeather, hourlyWeathers in
                [HourlyWeather(currentWeather: currentWeather)] + hourlyWeathers
            }
        
        let allClothingItems = Observable.combineLatest(
            hourlyWeatherItem,
            userGender,
            userTemperatureSensitiveness,
            leaveTime,
            returnTime
        )
            .flatMap { weathers, gender, userTemperatureSensitiveness, leaveTime, returnTime in
                self.clothingUseCase.fetchCurrentRecommendedCloting(
                    for: weathers,
                    in: gender,
                    leaveTime: leaveTime,
                    returnTime: returnTime,
                    temperatureSensitiveness: userTemperatureSensitiveness
                )
            }
            .map {
                $0.map { ClothesItemViewModel($0) }
            }
            .share(replay: 1)

        let touchedButton = Observable.combineLatest(
            Observable.merge(input.viewWillAppear.take(1), input.randomButtonTapped),
            allClothingItems
        )

        let recommendedClotingItemViewModel = touchedButton
            .map { _, items in
                ClothesType.allCases.compactMap { type in
                    items.filter { $0.type == type }.randomElement() ?? ClothesItemViewModel(type: type)
                }
            }
            .share()
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

        let allClothingViewDismiss = input.allClotingButtonTapped
            .withUnretained(self.coordinator)
            .flatMap { coordinator, _ in
                coordinator.coordinateToAllClothing(for: allClothingItems)
            }

        let leaveReturnTitleText = Observable.combineLatest(leaveTime, returnTime)
            .map { leaveTime, returnTime in
                (leaveTime.convert(to: .hourlyWeatherTime),
                 returnTime.convert(to: .hourlyWeatherTime))
            }
            .map { "\($0.0) 외출 \($0.1) 복귀"}

        return Output(
            locationAddress: locationAddress,
            isCurrentLocation: isCurrentLocation,
            currentTemperatureLabelText: currentTemperatureLabelText,
            currentWeatherConditionImageURL: currentWeatherConditionImageURL,
            currentWeatherCondition: currentWeatherCondition,
            minMaxTemperature: minMaxTemperature,
            hourlyWeatherItem: hourlyWeatherItemViewModel,
            dailyWeatherItem: dailyWeatherItemViewModel,
            allClotingItem: allClothingItems,
            recommendedClotingItem: recommendedClotingItemViewModel,
            leaveReturnTitleText: leaveReturnTitleText,
            allClothingViewDismiss: allClothingViewDismiss,
            initialLeaveTime: initialLeaveTimeSliderVlaue,
            initialReturnTIme: initialReturnTimeSliderValue
        )
    }
}
