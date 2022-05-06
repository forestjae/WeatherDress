//
//  WeatherCacheService.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/06.
//

import Foundation
import RxSwift

class WeatherCacheService {

    static let shared = WeatherCacheService()

    let ultraShortNowcastCache = NSCache<NSString, CacheValue<UltraShortNowcastWeatherItem>>()
    let ultraShortForecastCache = NSCache<NSString, CacheValue<UltraShortForecastWeatherList>>()
    let shortForecastCache = NSCache<NSString, CacheValue<ShortForecastWeatherList>>()
    let midWeatherForecastCache = NSCache<NSString, CacheValue<[MidForecastWeatherItem]>>()
    let midTemperatureForecastCache = NSCache<NSString, CacheValue<[MidForecastTemperatureItem]>>()

    func fetchUltraShortNowcast(
        for location: LocationInfo,
        at date: Date
    ) -> UltraShortNowcastWeatherItem? {
        let key = self.convertToKey(for: location, date: date, dateFormat: .ultraShortNowcastTime)
        if let value = self.ultraShortNowcastCache.object(forKey: key) {
            return value.value
        } else {
            return nil
        }
    }

    func fetchUltraShortForecast(
        for location: LocationInfo,
        at date: Date
    ) -> UltraShortForecastWeatherList? {
        let key = self.convertToKey(for: location, date: date, dateFormat: .ultraShortForecastTime)
        if let value = self.ultraShortForecastCache.object(forKey: key) {
            return value.value
        } else {
            return nil
        }
    }

    func fetchShortForecast(
        for location: LocationInfo,
        at date: Date
    ) -> ShortForecastWeatherList? {
        let key = self.convertToKey(for: location, date: date, dateFormat: .shortForecastTime)
        if let value = self.shortForecastCache.object(forKey: key) {
            return value.value
        } else {
            return nil
        }
    }

    func fetchMidWeatherForecast(
        for location: LocationInfo,
        at date: Date
    ) -> [MidForecastWeatherItem]? {
        let key = self.convertToKey(
            for: location,
               date: date,
               dateFormat: .midForecastRequestableTime
        )
        if let value = self.midWeatherForecastCache.object(forKey: key) {
            return value.value
        } else {
            return nil
        }
    }

    func fetchMidTemperatureForecast(
        for location: LocationInfo,
        at date: Date
    ) -> [MidForecastTemperatureItem]? {
        let key = self.convertToKey(
            for: location,
               date: date,
               dateFormat: .midForecastRequestableTime
        )
        if let value = self.midTemperatureForecastCache.object(forKey: key) {
            return value.value
        } else {
            return nil
        }
    }

    func convertToKey(
        for location: LocationInfo,
        date: Date,
        dateFormat: DateFormatter
    ) -> NSString {
        return location.address.fullAddress + date.convert(to: dateFormat) as NSString
    }
}
