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

    var coordinator: PageSceneCoordinator?

    private let disposeBag = DisposeBag()
    private let useCase: LocationUseCase
    private(set) var locations = PublishSubject<[LocationInfo]>()
    private(set) var locationButtonDidTap = PublishSubject<Void>()

    init(useCase: LocationUseCase) {
        self.useCase = useCase
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let locationButtonDidTap: Observable<Void>
    }

    struct Output {
        let locations: Observable<[LocationInfo]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let locations = input.viewWillAppear
            .flatMap {
                self.useCase.fetchLocations()
            }

        locations
            .subscribe(onNext: {
                self.locations.onNext($0)
            })
            .disposed(by: self.disposeBag)

        input.locationButtonDidTap
            .subscribe(onNext: {
                self.locationButtonDidTap.onNext($0)
            })
            .disposed(by: self.disposeBag)

        return Output(
            locations: self.locations
        )
    }
}
