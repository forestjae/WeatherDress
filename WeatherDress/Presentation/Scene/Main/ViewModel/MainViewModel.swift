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

    let coordinator: PageSceneCoordinator

    private let disposeBag = DisposeBag()
    private let useCase: LocationUseCase

    init(useCase: LocationUseCase, coordinator: PageSceneCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let locationButtonDidTap: Observable<Void>
    }

    struct Output {
        let locations: Driver<[LocationInfo]>
        let currentIndex: Driver<Int>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locations = self.useCase.fetchLocations()
            .share()
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] locations in
                self?.coordinator.setChildViewController(with: locations)
            })
            .asDriver(onErrorJustReturn: [])

        let currentIndex = input.locationButtonDidTap
            .withUnretained(self.coordinator)
            .flatMap { coordinator, _ in
                coordinator.coordinateToLocationList()
            }
            .asDriver(onErrorJustReturn: 0)

        return Output(
            locations: locations,
            currentIndex: currentIndex
        )
    }
}
