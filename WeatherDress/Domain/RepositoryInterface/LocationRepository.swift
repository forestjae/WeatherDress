//
//  LocationRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/08.
//

import Foundation
import RxSwift

protocol LocationRepository {
    func fetchLocations() -> Observable<LocationInfo>
}
