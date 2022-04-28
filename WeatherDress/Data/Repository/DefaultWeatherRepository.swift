//
//  DefaultWeatherRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/05.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultWeatherRepository: WeatherRepository {
    let apiService: WeatherService
    private let disposeBag = DisposeBag()

    init(apiService: WeatherService) {
        self.apiService = apiService
    }

    func fetch(from location: LocationInfo) -> Observable<UltraShortNowcastWeatherItem?> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )
        return self.apiService.fetchUltraShortNowcastWeather(
            xAxisNumber: converted.xGrid,
            yAxisNumber: converted.yGRid
        ).asObservable()
    }

    func fetchHourlyWeathers(from location: LocationInfo) -> Observable<[HourlyWeather]> {
        let converted = GridConverting.convertGRID_GPS(
            mode: .toGrid,
            xComponent: location.longtitude,
            yComponent: location.latitude
        )

        return Observable.combineLatest(
            self.apiService.fetchUltraShortForecastWeather(xAxisNumber: converted.xGrid, yAxisNumber: converted.yGRid)
                .map { $0.forecastList.map { item in
                    HourlyWeather(
                        date: item.forecastDate,
                        weatherCondition: DailyWeather.convertedFrom(item.skyCondition, rainFall2: item.rainfallType),
                        temperature: Int(item.temperature)
                    )
                }}
                .asObservable(),
            self.apiService.fetchShortForecastWeather(xAxisNumber: converted.xGrid, yAxisNumber: converted.yGRid)
            .map { $0.forecastList.map { item in
                HourlyWeather(
                    date: item.forecastDate,
                    weatherCondition: DailyWeather.convertedFrom(item.skyCondition, rainFall: item.rainfallType),
                    temperature: Int(item.temperatureForAnHour)
                )
            }}.asObservable().startWith([]))
            .map { ustList, stList in
                ustList + stList.filter { !ustList.map { $0.date }.contains($0.date) }
            }
            .map { $0.sorted { $0.date < $1.date }}
    }

    func fetchDailyWeathers(from location: LocationInfo) -> Observable<[DailyWeather]> {
        let address = location.address.fullAddress
        let temperatureCode = RegionCodeConverting.shared.convert(from: address, to: .temperature) ?? ""
        let weatherCode = RegionCodeConverting.shared.convert(from: address, to: .weather) ?? ""
        return Observable.zip(
            self.apiService.fetchMidForecastWeather(regionCode: weatherCode).asObservable(),
            self.apiService.fetchMidForecastTemperature(regionCode: temperatureCode).asObservable())
            .map { weather, temperature in
                zip(weather, temperature)
                    .map { weather, temperature in
                        DailyWeather(date: Date(timeIntervalSinceNow: Double(weather.date * 3600 * 24)),
                                     weatherCondition: MidForecastWeatherItem.convertedFrom(weather.weatherCondtion),
                                     rainfallProbability: weather.afterNoonRainfallProbability,
                                     maximumTemperature: temperature.maxTemperature,
                                     minimunTemperature: temperature.minTemperature
                        )
                    }
            }
    }
}

extension DailyWeather {
    static func convertedFrom(_ skyCondtion: SkyCondition, rainFall: ShortForecastRainfall) -> WeatherCondition {
        switch (skyCondtion, rainFall) {
        case (.clear, .none):
            return .clear
        case (.cloudy, .none):
            return .partlyCloudy
        case (.hazy, .none):
            return .cloudy
        case (.clear, .rain), (.clear, .shower), (.cloudy, .rain), (.cloudy, .shower),(.hazy, .rain), (.hazy, .shower):
            return .rain
        case (.clear, .snow), (.clear, .snowAndRain),(.cloudy, .snow), (.cloudy, .snowAndRain),(.hazy, .snow), (.hazy, .snowAndRain):
            return .snow
        }
    }

    static func convertedFrom(_ skyCondtion: SkyCondition, rainFall2: UltraShortNowcastRainfall) -> WeatherCondition {
        switch (skyCondtion, rainFall2) {
        case (.clear, .none):
            return .clear
        case (.cloudy, .none):
            return .partlyCloudy
        case (.hazy, .none):
            return .cloudy
        case (.clear, .rain), (.clear, .raindrops), (.cloudy, .rain), (.cloudy, .raindrops), (.hazy, .rain), (.hazy, .raindrops) :
            return .rain
        case (.clear, .snow), (.clear, .snowAndRain), (.clear, .raindropsAndSnowflakes),
            (.clear, .snowflakes), (.cloudy, .snow), (.cloudy, .snowAndRain),
            (.cloudy, .raindropsAndSnowflakes), (.cloudy, .snowflakes),
            (.hazy, .snow), (.hazy, .snowAndRain), (.hazy, .raindropsAndSnowflakes), (.hazy, .snowflakes):
            return .snow
        }
    }
}

extension MidForecastWeatherItem {
    static func convertedFrom(_ forecast: MidRoughForecast) -> WeatherCondition {
        switch forecast {
        case .clear:
            return .clear
        case .partlyCloudy:
            return .partlyCloudy
        case .cloudy:
            return .cloudy
        case .cloudyAndRainy, .cloudyAndShower, .partlyCloudyAndRainy, .partlyCloudyAndShower:
            return .rain
        case .cloudyAndSnowy, .partlyCloudyAndSnowy, .cloudyAndSleet, .partlyCloudyAndSleet:
            return .snow
        }
    }
}
