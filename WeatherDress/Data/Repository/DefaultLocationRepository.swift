//
//  DefaultRegionRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import RxSwift

final class DefaultLocationRepository: LocationRepository {
    let apiService: GeoSearchService
    private let disposeBag = DisposeBag()
    let locations: [LocationInfo] = []
    let relay = PublishSubject<LocationInfo>()

    init(apiService: GeoSearchService) {
        self.apiService = apiService
        self.apiService.coordinateToAddress(xCoordinate: 127.1, yCoordinate: 37.3414386)
            .subscribe(onSuccess: {
                self.relay.onNext($0)
            })
            .disposed(by: self.disposeBag)
    }

    func fetchLocations() -> Observable<LocationInfo> {
        return self.relay.asObserver()
    }
}
