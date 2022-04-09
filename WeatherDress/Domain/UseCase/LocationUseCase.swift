//
//  LocationUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation
import RxSwift

final class LocationUseCase {
    let repository: LocationRepository

    init(repository: LocationRepository) {
        self.repository = repository
    }

    func fetch() -> Observable<LocationInfo> {
        return self.repository.fetchLocations()
    }
}
