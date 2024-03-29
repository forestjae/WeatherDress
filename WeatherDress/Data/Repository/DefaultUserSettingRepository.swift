//
//  DefaultUserSettingRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import Foundation
import RxSwift

final class DefaultUserSettingRepository: UserSettingRepository {
    let userDefault = UserDefaults.standard

    func setUserInitialSettingDone() {
        self.userDefault.set(true, forKey: "InitialSettingDone")
    }

    func setUserGender(for gender: Gender) {
        self.userDefault.set(gender.rawValue, forKey: "Gender")
    }

    func setUserTemperatureSensitive(for temperatureSensitive: TemperatureSensitiveness) {
        self.userDefault.set(temperatureSensitive.rawValue, forKey: "TemperatureSensitive")
    }

    func setUserLeaveTime(for time: String) {
        self.userDefault.set(time, forKey: "LeaveTime")
    }

    func setUserReturnTime(for time: String) {
        self.userDefault.set(time, forKey: "ReturnTime")
    }

    func getUserGender() -> Observable<String?> {
        return self.userDefault.rx.observe(String.self, "Gender")
    }

    func getUserTemperatureSensitive() -> Observable<Int?> {
        return self.userDefault.rx.observe(Int.self, "TemperatureSensitive")
    }

    func getUserLeaveTime() -> Observable<String?> {
        return self.userDefault.rx.observe(String.self, "LeaveTime")
    }

    func getUserReturnTime() -> Observable<String?> {
        return self.userDefault.rx.observe(String.self, "ReturnTime")
    }
}
