//
//  UserSettingUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/07/05.
//

import Foundation
import RxSwift

protocol UserSettingUseCase {
    func setUserGender(for gender: Gender)
    func setUserTemperatureSensitive(for temperatureSensitive: TemperatureSensitiveness)
    func setUserLeaveTime(for time: String)
    func setUserReturnTime(for time: String)
    func getUserGender() -> Observable<Gender?>
    func getUserTemperatureSensitive() -> Observable<TemperatureSensitiveness?>
    func getUserLeaveTime() -> Observable<String?>
    func getUserReturnTime() -> Observable<String?>
}
