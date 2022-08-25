//
//  MockUserSettingUseCase.swift
//  WeatherDressViewModelTests
//
//  Created by Lee Seung-Jae on 2022/08/09.
//

import Foundation
import RxSwift

class MockUserSettingUseCase: UserSettingUseCase {
    private let dummyUserGender = BehaviorSubject<Gender?>(value: .male)
    private let dummyUserTemperatureSensitive = BehaviorSubject<TemperatureSensitiveness?>(
        value: .normal
    )
    private let dummyUserLeaveTime = BehaviorSubject<String?>(value: "1000")
    private let dummyUserReturnTime = BehaviorSubject<String?>(value: "1900")


    func setUserGender(for gender: Gender) {
        self.dummyUserGender.onNext(gender)
    }

    func setUserTemperatureSensitive(for temperatureSensitive: TemperatureSensitiveness) {
        self.dummyUserTemperatureSensitive.onNext(temperatureSensitive)
    }

    func setUserLeaveTime(for time: String) {
        self.dummyUserLeaveTime.onNext(time)
    }

    func setUserReturnTime(for time: String) {
        self.dummyUserReturnTime.onNext(time)
    }

    func getUserGender() -> Observable<Gender?> {
        return self.dummyUserGender
    }

    func getUserTemperatureSensitive() -> Observable<TemperatureSensitiveness?> {
        return self.dummyUserTemperatureSensitive
    }

    func getUserLeaveTime() -> Observable<String?> {
        return self.dummyUserLeaveTime
    }

    func getUserReturnTime() -> Observable<String?> {
        return self.dummyUserReturnTime
    }
}
