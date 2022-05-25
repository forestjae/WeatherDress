//
//  DefaultUserSettingRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import Foundation
import RxSwift

class DefaultUserSettingRepository: UserSettingRepository {
    let userDefault = UserDefaults.standard

    func setUserGender(for gender: Gender) {
        self.userDefault.set(gender.rawValue, forKey: "Gender")
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

    func getUserLeaveTime() -> Observable<String?> {
        return self.userDefault.rx.observe(String.self, "LeaveTime")
    }

    func getUserReturnTime() -> Observable<String?> {
        return self.userDefault.rx.observe(String.self, "ReturnTime")
    }
}
