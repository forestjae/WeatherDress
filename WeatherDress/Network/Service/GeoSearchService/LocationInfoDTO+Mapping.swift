//
//  LocationInfoDTO+Mapping.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/07/05.
//

import Foundation

extension LocationInfo {
    init?(searchedAddressSet: AddressSearchResponse.AddressSet) {
        guard searchedAddressSet.address.region2DepthName != "" else {
            return nil
        }
        guard let longtitude = Double(searchedAddressSet.xCoordinate),
              let latitude = Double(searchedAddressSet.yCoordinate) else {
                  return nil
              }
        self.identifier = UUID()
        self.longtitude = longtitude
        self.latitude = latitude
        let thirdRegion: String = {
            if searchedAddressSet.address.region3DepthName == "" {
                return searchedAddressSet.address.region3DepthHName
            } else {
                return searchedAddressSet.address.region3DepthName
            }
        }()

        self.address = Address(
            fullAddress: searchedAddressSet.address.addressName,
            firstRegion: searchedAddressSet.address.region1DepthName,
            secondRegion: searchedAddressSet.address.region2DepthName,
            thirdRegion: thirdRegion,
            fourthRegion: nil
        )
        self.isCurrent = false
    }
}
