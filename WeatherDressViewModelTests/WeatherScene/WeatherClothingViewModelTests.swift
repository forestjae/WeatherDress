//
//  WeatherViewModelTests.swift
//  WeatherDressViewModelTests
//
//  Created by Lee Seung-Jae on 2022/07/04.
//

import XCTest
import RxSwift
import Nimble
import RxTest
import RxNimble

class WeatherClothingViewModelTests: XCTestCase {
    private var viewModel: WeatherClothingViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var location = LocationInfo(
        identifer: UUID(),
        longtitude: 36.0,
        latitude: 123.0,
        address: .init(
            fullAddress: "경기도 수원시",
            firstRegion: "경기도",
            secondRegion: "수원시",
            thirdRegion: nil,
            fourthRegion: nil
        ),
        isCurrent: false
    )

    private var input: WeatherClothingViewModel.Input!
    private lazy var output: WeatherClothingViewModel.Output! = viewModel.transform(input: self.input, disposeBag: self.disposeBag)
    private var viewWillAppear: PublishSubject<Void>!
    private var randomButtonTapped: PublishSubject<Void>!
    private var allClothingButtonTapped: PublishSubject<Void>!
    private var timeConfigurationButtonTapped: PublishSubject<Void>!
    private var timeSliderLowerValueChanged: PublishSubject<Double>!
    private var timeSliderUpperValueChanged: PublishSubject<Double>!
    private var mockWeatherUseCase: MockWeatherUseCase!
    private var mockWeatherClothingCoordinator: MockWeatherClothingCoordinator!

    // Given
    override func setUp() {
        self.mockWeatherUseCase = MockWeatherUseCase()
        self.mockWeatherClothingCoordinator = MockWeatherClothingCoordinator()
        self.viewModel = WeatherClothingViewModel(
            coordinator: self.mockWeatherClothingCoordinator,
            useCase: self.mockWeatherUseCase,
            clothingUseCase: MockClothesUseCase(),
            userSettingUseCase: MockUserSettingUseCase(),
            location: self.location
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)

        self.viewWillAppear = PublishSubject<Void>()
        self.randomButtonTapped = PublishSubject<Void>()
        self.allClothingButtonTapped = PublishSubject<Void>()
        self.timeConfigurationButtonTapped = PublishSubject<Void>()
        self.timeSliderLowerValueChanged = PublishSubject<Double>()
        self.timeSliderUpperValueChanged = PublishSubject<Double>()

        self.input = WeatherClothingViewModel.Input(
            viewWillAppear: self.viewWillAppear,
            randomButtonTapped: self.randomButtonTapped,
            allClothingButtonTapped: self.allClothingButtonTapped,
            timeSliderLowerValueChanged: self.timeSliderLowerValueChanged,
            timeSliderUpperValueChnaged: self.timeSliderUpperValueChanged
        )
    }

    func test_fetchWeatherAndClothing_onViewWillAppearEvent() throws {
        // When
        let viewWillAppearTestableObservable = self.scheduler.createHotObservable([.next(10, ())])
        viewWillAppearTestableObservable.bind(to: self.viewWillAppear)
            .disposed(by: self.disposeBag)

        // Then
        let c = self.mockWeatherUseCase.dummyCurrentWeather
        let a = self.mockWeatherUseCase.dummyHourlyWeathers
        let b = self.mockWeatherUseCase.dummyDailyWeathers

        expect(self.output.dailyWeatherItem.asObservable).first.to(
            equal((a.toDaily() + b).enumerated()
                    .map { DailyWeatherItemViewModel(dailyWeather: $0.1, index: $0.0)})
        )

        expect(self.output.hourlyWeatherItem.asObservable).first.to(
            equal(([HourlyWeather(currentWeather: c)] + a).enumerated()
                    .map { HourlyWeatherItemViewModel(hourlyWeather: $0.1, index: $0.0)})
        )
        expect(self.output.locationAddress).first.to(equal("수원시  "))
        expect(self.output.allClothingItem).first.to(equal([]))
        expect(self.output.recommendedClothingItem).first.toNot(beNil())
    }

    func test_randomButtonTappedEvent() {
        //When
        let randomButtonTappedTestableObservable = self.scheduler.createColdObservable(
            [.next(10, ())]
        )
        randomButtonTappedTestableObservable.bind(to: self.randomButtonTapped)
            .disposed(by: self.disposeBag)

        expect(self.output.recommendedClothingItem).last.toNot(beNil())
    }

    func test_timeSliderLowerValueChanged() {
        let timeSliderLowerValueChangedTestableObservable = self.scheduler.createColdObservable(
            [.next(10, 10.0)]
        )

        let timeSliderUpperValueChangedTestableObservable = self.scheduler.createColdObservable(
            [.next(10, 20.0)]
        )

        timeSliderLowerValueChangedTestableObservable.bind(to: self.timeSliderLowerValueChanged)
            .disposed(by: self.disposeBag)

        timeSliderUpperValueChangedTestableObservable.bind(to: self.timeSliderUpperValueChanged)
            .disposed(by: self.disposeBag)

        expect(self.output.leaveReturnTitleText).first.to(equal("10시 - 20시"))
    }

    func test_timeSliderUpperValueChanged() {
        let timeSliderUpperValueChangedTestableObservable = self.scheduler.createColdObservable(
            [.next(10, 10.0)]
        )

        timeSliderUpperValueChangedTestableObservable.bind(to: self.timeSliderUpperValueChanged)
            .disposed(by: self.disposeBag)

        expect(self.output.r).first.to(equal(10.0))
    }
}
