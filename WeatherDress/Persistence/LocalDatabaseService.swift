//
//  LocalDatabaseService.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RxSwift

protocol LocalDatabaseService {
    func fetch() -> Observable<[LocationInfo]>
    func create(_ location: LocationInfo) -> Completable
    func delete(_ location: LocationInfo) -> Completable
}
