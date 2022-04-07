//
//  LocationInfo.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct LocationInfo {
    let longtitude: Double
    let latitude: Double
    let address: Address

    struct Address {
        let fullAddress: String
        let firstRegion: String
        let secondRegion: String
        let thirdRegion: String?
        let fourthRegion: String?
    }
}

extension LocationInfo {
    init?(searchedAddressSet: AddressSearchResponse.AddressSet) {
        guard let longtitude = Double(searchedAddressSet.xCoordinate),
              let latitude = Double(searchedAddressSet.yCoordinate) else {
                  return nil
              }
        self.longtitude = longtitude
        self.latitude = latitude
        self.address = Address(
            fullAddress: searchedAddressSet.address.addressName,
            firstRegion: searchedAddressSet.address.region1DepthName,
            secondRegion: searchedAddressSet.address.region2DepthName,
            thirdRegion: searchedAddressSet.address.region3DepthName,
            fourthRegion: nil)
    }
}
