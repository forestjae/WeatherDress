//
//  LocationInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct LocationInfo: Hashable {
    let identifier: UUID
    let longtitude: Double
    let latitude: Double
    let address: Address
    let isCurrent: Bool

    struct Address: Hashable {
        let fullAddress: String
        let firstRegion: String
        let secondRegion: String
        let thirdRegion: String?
        let fourthRegion: String?
    }

    init(
        identifer: UUID = UUID(),
        longtitude: Double,
        latitude: Double,
        address: Address,
        isCurrent: Bool = false
    ) {
        self.identifier = identifer
        self.longtitude = longtitude
        self.latitude = latitude
        self.address = address
        self.isCurrent = isCurrent
    }
}

extension LocationInfo {
    static let notServiced: LocationInfo = {
        return LocationInfo(
            identifer: UUID(),
            longtitude: 0.0,
            latitude: 0.0,
            address: .init(
                fullAddress: "",
                firstRegion: "",
                secondRegion: "",
                thirdRegion: nil,
                fourthRegion: nil
            ),
            isCurrent: true
        )
    }()
}

extension LocationInfo {
    func shortAddress() -> String {
        if self.address.firstRegion == "" {
            return "서비스가 불가능한 지역입니다"
        }
        return [self.address.secondRegion,
                self.address.thirdRegion ?? "",
                self.address.fourthRegion ?? ""]
            .joined(separator: " ")
    }
}
