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
    }

    func setLocationInfo(_ location: LocationInfo) {
        self.locationInfo.onNext(location)
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let initialLeaveTime = input.viewWillAppear
            .flatMap { _ in self.userSettingUseCase.getUserLeaveTime() }
            .compactMap { $0 }
            .map { DateFormatter.yearMonthDay.string(from: Date()) + $0 }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0) }

        let initialReturnTime = input.viewWillAppear
            .flatMap { _ in self.userSettingUseCase.getUserReturnTime() }
            .compactMap { $0 }
            .map { DateFormatter.yearMonthDay.string(from: Date()) + $0 }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0) }
            .debug()



        let leaveReturnTimeConfigured = input.timeConfigurationButtonTapped
                    .withLatestFrom(Observable.zip(initialLeaveTime, initialReturnTime))
                    .withUnretained(self.coordinator)
                    .flatMap { coordinator, leaveReturnTime in
                        coordinator.coordinateToTimeConfiguration(for: leaveReturnTime)
                    }
                    .compactMap { result -> (Date, Date)? in
                        switch result {
                        case .accept(let leaveTime, let returnTime):
                            return (leaveTime, returnTime)
                        case .cancel:
                            return nil
                        }
                    }
                    .share()

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



        let leaveTime = Observable.merge(initialLeaveTime, leaveReturnTimeConfigured.map { $0.0 })
            .share()
            .debug()

        let returnTime = Observable.merge(initialReturnTime, leaveReturnTimeConfigured.map { $0.1})
            .share()

        let userGender = self.userSettingUseCase.getUserGender()
            .compactMap { $0 }

        let hourlyWeatherItem = Observable.combineLatest(currentWeather, hourlyWeathers)
            .map { currentWeather, hourlyWeathers in
                [HourlyWeather(currentWeather: currentWeather)] + hourlyWeathers
            }
        
        let allClothingItems = Observable.combineLatest(
            hourlyWeatherItem,
            userGender,
            leaveTime,
            returnTime
        )
            .flatMap { weathers, gender, leaveTime, returnTime in
                self.clothingUseCase.fetchCurrentRecommendedCloting(
                    for: weathers,
                    in: gender,
                    leaveTime: leaveTime,
                    returnTime: returnTime
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
                    items.filter { $0.type == type }.randomElement()
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
            .debug()

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
            allClothingViewDismiss: allClothingViewDismiss
        )
    }
}
