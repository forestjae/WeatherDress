//
//  StorableLocationInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import Foundation
import RealmSwift

final class StorableLocationInfo: Object {
    @objc dynamic var identifer = ""
    @objc dynamic var longtitude = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var address: StorableAddress?
}

final class StorableAddress: Object {
    @objc dynamic var fullAddress = ""
    @objc dynamic var firstRegion = ""
    @objc dynamic var secondRegion = ""
    @objc dynamic var thirdRegion = ""
    @objc dynamic var fourthRegion = ""
}
