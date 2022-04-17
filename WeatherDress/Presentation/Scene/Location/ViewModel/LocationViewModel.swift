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

    init(useCase: LocationUseCase) {
        self.useCase = useCase
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let searchQuery: Observable<String>
        let searchResultCellDidTap: Observable<LocationInfo>
        let cellDidDeleted: Observable<LocationInfo>
        let newLocationOK: Observable<LocationViewController.ActionType>
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

        let searchResult = input.searchQuery
            .flatMap { string in
                self.useCase.search(for: string)
            }
            .asDriver(onErrorJustReturn: [])

//        _ = input.searchResultCellDidTap
//            .flatMap {
//                self.useCase.createLocation(location: $0)
//            }
//            .subscribe(onNext: { _ in
//                print("성공")
//            })
//            .disposed(by: self.disposeBag)

        input.cellDidDeleted
            .subscribe(onNext: {
                self.useCase.deleteLocation(location: $0)
                    .subscribe(onCompleted: { 
                        print("성공")
                    })
            })
            .disposed(by: self.disposeBag)

        input.newLocationOK
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
