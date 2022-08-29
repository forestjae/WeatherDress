//
//  AllClothingViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/21.
//

import Foundation
import RxSwift
import RxCocoa

final class AllClothingViewModel {
    let cancel: Observable<Void>

    private weak var coordinator: AllClothingCoordinator!
    private let clothes: Observable<[ClothesItemViewModel]>
    private let _cancel = PublishSubject<Void>()

    init(
        coordinator: AllClothingCoordinator,
        clothes: Observable<[ClothesItemViewModel]>
    ) {
        self.coordinator = coordinator
        self.clothes = clothes.share(replay: 1)
        self.cancel = self._cancel.asObservable()
    }

    struct Input {
        let cancelButtonDidTapped: Observable<Void>
    }

    struct Output {
        let outerClothingItem: Driver<[ClothesItemViewModel]>
        let topClothingItem: Driver<[ClothesItemViewModel]>
        let bottomsClothingItem: Driver<[ClothesItemViewModel]>
        let accessoryClothingItem: Driver<[ClothesItemViewModel]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.cancelButtonDidTapped
            .subscribe(self._cancel)
            .disposed(by: disposeBag)

        let outerClotingItemViewModel = self.clothes
            .map {
                $0.filter { $0.type == .outer }
            }
            .asDriver(onErrorJustReturn: [])

        let topClotingItemViewModel = self.clothes
            .map {
                $0.filter { $0.type == .top }
            }
            .asDriver(onErrorJustReturn: [])

        let bottomsClotingItemViewModel = self.clothes
            .map {
                $0.filter { $0.type == .bottoms }
            }
            .asDriver(onErrorJustReturn: [])

        let accessoryClotingItemViewModel = self.clothes
            .map {
                $0.filter { $0.type == .accessory }
            }
            .asDriver(onErrorJustReturn: [])

        return Output(
            outerClothingItem: outerClotingItemViewModel,
            topClothingItem: topClotingItemViewModel,
            bottomsClothingItem: bottomsClotingItemViewModel,
            accessoryClothingItem: accessoryClotingItemViewModel
        )
    }
}
