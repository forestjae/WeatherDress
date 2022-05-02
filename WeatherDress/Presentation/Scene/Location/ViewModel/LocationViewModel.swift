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
    private(set) var locationListCellDidDeletedAt = PublishSubject<Int>()

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
        let searchBarText: Observable<String>
        let searchResultCellDidTap: Observable<LocationInfo>
        let listCellDidDeleted: Observable<LocationInfo>
        let listCellDidDeletedAt: Observable<Int>
        let createLocationAlertDidAccepted: Observable<LocationViewController.ActionType>
    }

    struct Output {
        let locations: Driver<[LocationInfo]>
        let searchedLocations: Driver<[LocationInfo]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locations = input.viewWillAppear
            .flatMap {
                self.useCase.fetchLocations()
            }
            .asDriver(onErrorJustReturn: [])

        let searchResult = input.searchBarText
            .flatMap { string in
                self.useCase.search(for: string)
            }
            .asDriver(onErrorJustReturn: [])

        input.locationListCellSelected
            .subscribe(self.locationListCellDidTap)
            .disposed(by: self.disposeBag)

        input.listCellDidDeletedAt
            .subscribe(self.locationListCellDidDeletedAt)
            .disposed(by: self.disposeBag)

        input.listCellDidDeleted
            .subscribe(onNext: {
                self.useCase.deleteLocation(location: $0)
                    .subscribe(onCompleted: { 
                        print("성공")
                    })
            })
            .disposed(by: self.disposeBag)

        input.createLocationAlertDidAccepted
            .subscribe(onNext: { result in
                switch result {
                case .ok(let locationInfo):
                    self.useCase.createLocation(location: locationInfo)
                        .subscribe({ _ in
                            print("성공")
                        })
                case .cancel:
                    print("실패")
                }
            }
            )

        return Output(locations: locations, searchedLocations: searchResult)
    }
}
