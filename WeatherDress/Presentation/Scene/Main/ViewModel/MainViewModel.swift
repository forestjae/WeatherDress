//
//  MainViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation
import RxSwift
import RxDataSources

final class MainViewModel {

    let coordinator: PageSceneCoordinator

    private let disposeBag = DisposeBag()
    private let useCase: LocationUseCase
    private(set) var locationButtonDidTap = PublishSubject<Void>()

    init(useCase: LocationUseCase, coordinator: PageSceneCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let locationButtonDidTap: Observable<Void>
    }

    struct Output {
        let locations: Observable<[LocationInfo]>
        let currentIndex: Observable<Int>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locations = input.viewWillAppear
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.useCase.fetchLocations()
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] locations in
                self?.coordinator.setChildViewController(with: locations)
            })

        let currentIndex = input.locationButtonDidTap
            .compactMap {
                self.coordinator
            }
            .flatMap {
                $0.coordinateToLocationList()
            }

        return Output(
            locations: locations,
            currentIndex: currentIndex
        )
    }
}
