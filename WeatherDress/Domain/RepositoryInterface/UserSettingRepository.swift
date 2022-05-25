//
//  UserSettingRepository.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import Foundation
import RxSwift

protocol UserSettingRepository {
    func setUserGender(for gender: Gender)
    func setUserLeaveTime(for time: String)
    func setUserReturnTime(for time: String)
    func getUserGender() -> Observable<String?>
    func getUserLeaveTime() -> Observable<String?>
    func getUserReturnTime() -> Observable<String?>
}
