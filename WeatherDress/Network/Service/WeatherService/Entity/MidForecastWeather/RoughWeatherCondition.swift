//
//  RoughWeatherCondition.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/03.
//

import Foundation

enum RoughWeatherCondition: String {
    case clear = "맑음"
    case partlyCloudy = "구름많음"
    case partlyCloudyAndRainy = "구름많고 비"
    case partlyCloudyAndSnowy = "구름많고 눈"
    case partlyCloudyAndSleet = "구름많고 비/눈"
    case partlyCloudyAndShower = "구름많고 소나기"
    case cloudy = "흐림"
    case cloudyAndRainy = "흐리고 비"
    case cloudyAndSnowy = "흐리고 눈"
    case cloudyAndSleet = "흐리고 비/눈"
    case cloudyAndShower = "흐리고 소나기"
}
