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
    init?(searchedAddressSet: AddressSearchResponse.AddressSet) {
        guard let longtitude = Double(searchedAddressSet.xCoordinate),
              let latitude = Double(searchedAddressSet.yCoordinate) else {
                  return nil
              }
        self.identifier = UUID()
        self.longtitude = longtitude
        self.latitude = latitude
        self.address = Address(
            fullAddress: searchedAddressSet.address.addressName,
            firstRegion: searchedAddressSet.address.region1DepthName,
            secondRegion: searchedAddressSet.address.region2DepthName,
            thirdRegion: searchedAddressSet.address.region3DepthName,
            fourthRegion: nil
        )
        self.isCurrent = false
    }
}

extension LocationInfo {
    func shortAddress() -> String {
        return [self.address.secondRegion,
                self.address.thirdRegion ?? "",
                self.address.fourthRegion ?? ""]
            .joined(separator: " ")
    }
}
