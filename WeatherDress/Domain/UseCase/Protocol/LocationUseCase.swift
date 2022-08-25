//
//  LocationUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/07/05.
//

import Foundation
import RxSwift

protocol LocationUseCase {
    func fetchCurrentLocations() -> Observable<LocationInfo>
    func fetchFavoriteLocations() -> Observable<[LocationInfo]>
    func deleteLocation(location: LocationInfo) -> Completable
    func createLocation(location: LocationInfo) -> Completable
    func search(for query: String) -> Observable<[LocationInfo]>
}
