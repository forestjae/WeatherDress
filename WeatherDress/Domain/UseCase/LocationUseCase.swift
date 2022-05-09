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

    func fetchLocations() -> Observable<[LocationInfo]> {
        return Observable.combineLatest(
            self.repository.fetchCurrentLocation(),
            self.repository.fetchFavoriteLocations()
        )
        .debug()
        .map { [$0] + $1 }
    }

    func deleteLocation(location: LocationInfo) -> Completable {
        return self.repository.deleteLocation(location: location)
    }

    func createLocation(location: LocationInfo) -> Completable {
        return self.repository.createLocation(location: location)
    }

    func search(for query: String) -> Observable<[LocationInfo]> {
        if query == "" {
            return self.repository.searchLocation(for: " ")
        }
        return self.repository.searchLocation(for: query)
    }
}
