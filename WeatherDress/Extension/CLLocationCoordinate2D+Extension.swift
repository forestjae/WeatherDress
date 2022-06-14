//
//  CLLocationCoordinate2D+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/13.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
