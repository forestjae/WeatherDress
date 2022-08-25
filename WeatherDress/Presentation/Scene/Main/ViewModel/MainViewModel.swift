//
//  MainViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {

    struct Input {
        let viewWillAppear: Observable<Void>
        let locationButtonDidTap: Observable<Void>
        let configurationButtonDidTap: Observable<Void>
    }

    struct Output {
        let currentLocation: Observable<LocationInfo>
        let locations: Driver<Int>
        let currentIndex: Driver<Int>
        let currentLocationAvailable: Driver<Bool>
        let anyLocationAvailable: Driver<Bool>
    }

    private let coordinator: MainCoordinator
    private let useCase: DefaultLocationUseCase

    init(useCase: DefaultLocationUseCase, coordinator: MainCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let currentLocationIsVisible = BehaviorSubject<Bool>(value: false)
        let currentLocationAvailable = LocationManager.shared.authorizationStatus()
            .map { status -> Bool in
                switch status {
                case .denied:
                    return false
                default:
                    return true
                }
            }

        currentLocationIsVisible
            .subscribe()
            .disposed(by: disposeBag)

        let currentLocation = self.useCase.fetchCurrentLocations()
            .share()

        let favoriteLocations = input.viewWillAppear
            .take(1)
            .flatMap { self.useCase.fetchFavoriteLocations() }
            .share()

        _ = currentLocation
            .withLatestFrom(
                currentLocationIsVisible,
                resultSelector: { location, isVisible in
                (location, isVisible)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] location, isVisible in
                self?.coordinator.setCurrentLocationWeatherViewController(
                    with: location,
                    isVisible: isVisible
                )
                currentLocationIsVisible.onNext(true)
            })
            .subscribe()

        _ = currentLocationAvailable
            .withLatestFrom(
                currentLocationIsVisible,
                resultSelector: { isAvailable, isVisible -> Bool in
                    isVisible == true && isAvailable == false
            })
            .filter { $0 == true }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.coordinator.deleteCurrentLocationWeatherViewController()
                currentLocationIsVisible.onNext(false)
            })
            .subscribe()

        _ = Observable.combineLatest(
            favoriteLocations,
            currentLocationIsVisible.skip(1)
        )
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] locations, isVisible in
                self?.coordinator.setChildViewController(with: locations, isCurrentVisible: isVisible)
            })
            .map { $0.0 }
            .subscribe()

        let locationCount = Observable.combineLatest(
            currentLocationAvailable.map { $0 ? 1 : 0},
            favoriteLocations.map { $0.count }
        )
            .map { $0.0 + $0.1 }
            .asDriver(onErrorJustReturn: 0)

        let anyLocationAvailable = locationCount
            .map { $0 != 0 }

        let currentIndex = input.locationButtonDidTap
            .withUnretained(self.coordinator)
            .flatMap { coordinator, _ in
                coordinator.coordinateToLocationList()
            }
            .asDriver(onErrorJustReturn: 0)

        input.configurationButtonDidTap
            .withUnretained(self.coordinator)
            .flatMap { coordinator, _ in
                coordinator.coordinateToUserSetting()
            }
            .subscribe()
            .disposed(by: disposeBag)

        currentLocationAvailable
            .subscribe(onNext: {
                $0 ? () : currentLocationIsVisible.onNext(false)
            })
            .disposed(by: disposeBag)

        return Output(
            currentLocation: currentLocation,
            locations: locationCount,
            currentIndex: currentIndex,
            currentLocationAvailable: currentLocationAvailable.asDriver(onErrorJustReturn: false),
            anyLocationAvailable: anyLocationAvailable
        )
    }
}
