//
//  CacheValue.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/07.
//

import Foundation

class CacheValue<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}
