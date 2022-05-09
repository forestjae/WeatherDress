//
//  LocationViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RxSwift
import RxCocoa

class LocationViewModel {

    private let disposeBag = DisposeBag()
    private let useCase: LocationUseCase
    private let weatherUseCase: WeatherUseCase
    private let coordinator: LocationListCoordinator
    private(set) var locationListCellDidTap = PublishSubject<Int>()

    init(
        useCase: LocationUseCase,
        weatherUseCase: WeatherUseCase,
        coordinator: LocationListCoordinator
    ) {
        self.useCase = useCase
        self.weatherUseCase = weatherUseCase
        self.coordinator = coordinator
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let locationListCellSelected: Observable<Int>
        let listCellDidDeleted: Observable<LocationInfo>
        let acceptedToCreateLocation: Observable<LocationInfo>
        let searchBarText: BehaviorRelay<String>
        let searchResultCellDidTap: Observable<LocationInfo>
    }

    struct Output {
        let locations: Observable<[LocationInfo]>
        let weathers: Observable<[CurrentWeather]>
        let searchedLocations: Driver<[LocationInfo]>
        let locationDidDeleted: Observable<Void>
        let newLocationCreated: Observable<Void>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locations = input.viewWillAppear
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.useCase.fetchLocations()
            }
            .share()

        let weathers = locations
            .withUnretained(self)
            .flatMap { viewModel, locations in
                Observable.zip(
                    locations.map { viewModel.weatherUseCase.fetchCurrentWeather(from: $0) }
                )
            }
            .share()

        let searchResult = input.searchBarText
            .withUnretained(self)
            .flatMap { viewModel, query in
                viewModel.useCase.search(for: query)
            }
            .asDriver(onErrorJustReturn: [])

        input.locationListCellSelected
            .subscribe(self.locationListCellDidTap)
            .disposed(by: self.disposeBag)

        let locationDidDeleted = input.listCellDidDeleted
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.useCase.deleteLocation(location: location)
            }
            .map { _ in }

        let newLocationCreated = input.acceptedToCreateLocation
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.useCase.createLocation(location: location)
            }
            .map { _ in }

        return Output(
            locations: locations,
            weathers: weathers,
            searchedLocations: searchResult,
            locationDidDeleted: locationDidDeleted,
            newLocationCreated: newLocationCreated
        )
    }
}
