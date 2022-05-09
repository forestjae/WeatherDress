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
    private let disposeBag = DisposeBag()
    private let apiService: GeoSearchService
    private let dataBase: LocalDatabaseService
    private let currentLocation: Observable<LocationInfo>

    init(apiService: GeoSearchService, database: LocalDatabaseService) {
        self.apiService = apiService
        self.dataBase = database
        self.currentLocation = LocationManager.shared.currentLocation()
            .share()
            .flatMap {
                apiService.coordinateToAddress(
                xCoordinate: $0.coordinate.longitude,
                yCoordinate: $0.coordinate.latitude
                )}
    }

    func fetchCurrentLocation() -> Observable<LocationInfo> {
        return self.currentLocation
    }

    func fetchFavoriteLocations() -> Observable<[LocationInfo]> {
        return self.dataBase.fetch()
    }

    func deleteLocation(location: LocationInfo) -> Completable {
        return self.dataBase.delete(location)
            .andThen(Completable.create { completable in
                completable(.completed)
                return Disposables.create()
            })
    }

    func createLocation(location: LocationInfo) -> Completable {
        return self.dataBase.create(location)
            .andThen(Completable.create { completable in
                completable(.completed)
                return Disposables.create()
            })
    }

    func searchLocation(for query: String) -> Observable<[LocationInfo]> {
        return self.apiService.searchAddress(by: query).asObservable()
    }
}
