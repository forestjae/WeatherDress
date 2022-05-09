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
    private let favoriteLocations: BehaviorSubject<[LocationInfo]>
    private let currentLocation: BehaviorSubject<LocationInfo?>

    init(apiService: GeoSearchService, database: LocalDatabaseService) {
        self.apiService = apiService
        self.dataBase = database
        self.favoriteLocations = BehaviorSubject(value: self.dataBase.fetch())
        self.currentLocation = BehaviorSubject(value: nil)
        _ = LocationManager.shared.currentLocation()
            .flatMap {
                apiService.coordinateToAddress(
                xCoordinate: $0.coordinate.longitude,
                yCoordinate: $0.coordinate.latitude
                )}
            .subscribe(onNext: { [weak self] in
                self?.currentLocation.onNext($0)
            })
    }

    func fetchCurrentLocation() -> Observable<LocationInfo?> {
        return self.currentLocation
    }

    func fetchFavoriteLocations() -> Observable<[LocationInfo]> {
        return self.favoriteLocations.asObservable()
    }

    func deleteLocation(location: LocationInfo) -> Completable {
        return self.dataBase.delete(location)
            .andThen(Completable.create { completable in
                self.favoriteLocations.onNext(self.dataBase.fetch())
                completable(.completed)
                return Disposables.create()
            })
    }

    func createLocation(location: LocationInfo) -> Completable {
        return self.dataBase.create(location)
            .andThen(Completable.create { completable in
                self.favoriteLocations.onNext(self.dataBase.fetch())
                completable(.completed)
                return Disposables.create()
            })
    }

    func searchLocation(for query: String) -> Observable<[LocationInfo]> {
        return self.apiService.searchAddress(by: query).asObservable()
    }
}

let sharedRepo = DefaultLocationRepository(apiService: GeoSearchService(apiProvider: DefaultAPIProvider()), database: RealmService()!)
