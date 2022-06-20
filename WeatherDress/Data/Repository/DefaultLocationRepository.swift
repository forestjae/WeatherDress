//
//  DefaultRegionRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import RxSwift
import CoreLocation

final class DefaultLocationRepository: LocationRepository {
    private let apiService: GeoSearchService
    private let dataBase: LocalDatabaseService

    init(apiService: GeoSearchService, database: LocalDatabaseService) {
        self.apiService = apiService
        self.dataBase = database
    }

    func fetchCurrentLocation() -> Observable<LocationInfo> {
        return LocationManager.shared.currentLocation()
            .filter { $0.coordinate.latitude != 0.0 }
            .withUnretained(self)
            .flatMap { repository, location in
                repository.apiService.coordinateToAddress(
                    xCoordinate: location.coordinate.longitude,
                    yCoordinate: location.coordinate.latitude
                )
                .catchAndReturn(LocationInfo.notServiced)
            }
    }

    func fetchFavoriteLocations() -> Observable<[LocationInfo]> {
        return self.dataBase.fetch()
    }

    func deleteLocation(location: LocationInfo) -> Completable {
        return self.dataBase.delete(location)
    }

    func createLocation(location: LocationInfo) -> Completable {
        return self.dataBase.create(location)
    }

    func searchLocation(for query: String) -> Observable<[LocationInfo]> {
        return self.apiService.searchAddress(by: query).asObservable()
    }
}
