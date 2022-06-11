//
//  UserSettingUseCase.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import Foundation
import RxSwift

class UserSetttingUseCase {

    let repository: UserSettingRepository

    init(repository: UserSettingRepository) {
        self.repository = repository
    }

    func setUserGender(for gender: Gender) {
        self.repository.setUserGender(for: gender)
    }

    func setUserTemperatureSensitive(for temperatureSensitive: TemperatureSensitive) {
        self.repository.setUserTemperatureSensitive(for: temperatureSensitive)
    }

    func setUserLeaveTime(for time: String) {
        self.repository.setUserLeaveTime(for: time)
    }

    func setUserReturnTime(for time: String) {
        self.repository.setUserReturnTime(for: time)
    }

    func getUserGender() -> Observable<Gender?> {
        return self.repository.getUserGender()
            .compactMap { $0 }
            .map { Gender(rawValue: $0) }
    }

    func getUserTemperatureSensitive() -> Observable<TemperatureSensitive?> {
        return self.repository.getUserTemperatureSensitive()
            .compactMap { $0 }
            .map { TemperatureSensitive(rawValue: $0)}
    }

    func getUserLeaveTime() -> Observable<String?> {
        return self.repository.getUserLeaveTime()
    }

    func getUserReturnTime() -> Observable<String?> {
        return self.repository.getUserReturnTime()
    }
}
