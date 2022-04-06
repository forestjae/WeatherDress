//
//  MainViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation
import RxSwift

final class MainViewModel {

    private let bag = DisposeBag()
    private let useCase: WeatherUsecase
    private let weather: Observable<UltraShortNowcastWeatherItem?>

    init(useCase: WeatherUsecase) {
        self.useCase = useCase
        self.weather = self.useCase.fetch()
    }

    struct Input {
        let viewWillAppear: Observable<Void>
    }

    struct Output {
        //let locationLabelText: Observable<String>
        //let currentWeatherImageName: Observable<String>
        let currentTemperatureLabelText: Observable<String>
//        let currentWeatherConditionLabelText: Observable<String>
//        let currentWeatherDescriptionLabelText: Observable<String>
//        let currentMinMaxTemperatureLabelText: Observable<(String, String)>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.useCase.fetchCurrentWeather()
            })
            .disposed(by: disposeBag)

        let currentTemperatureLabelText = self.weather
            .compactMap { $0 }
            .compactMap { String($0.temperature) }

        return Output(
            currentTemperatureLabelText: currentTemperatureLabelText
        )
    }
}
