//
//  LocationUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation
import RxSwift

final class DefaultLocationUseCase: LocationUseCase {
    let repository: LocationRepository

    init(repository: LocationRepository) {
        self.repository = repository
    }

    func fetchCurrentLocations() -> Observable<LocationInfo> {
        self.repository.fetchCurrentLocation()
    }

    func fetchFavoriteLocations() -> Observable<[LocationInfo]> {

        self.repository.fetchFavoriteLocations()
    }

    func deleteLocation(location: LocationInfo) -> Completable {
        return self.repository.deleteLocation(location: location)
    }

    func createLocation(location: LocationInfo) -> Completable {
        return self.repository.createLocation(location: location)
    }

    func search(for query: String) -> Observable<[LocationInfo]> {
        return self.repository.searchLocation(for: query == "" ? " " : query)
    }
}
