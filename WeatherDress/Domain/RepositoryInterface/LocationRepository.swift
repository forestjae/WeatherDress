//
//  LocationRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import RxSwift

protocol LocationRepository {
    func fetchCurrentLocation() -> Observable<LocationInfo?>
    func fetchFavoriteLocations() -> Observable<[LocationInfo]>
    func deleteLocation(location: LocationInfo) -> Completable
    func createLocation(location: LocationInfo) -> Completable
    func searchLocation(for query: String) -> Observable<[LocationInfo]>
}
