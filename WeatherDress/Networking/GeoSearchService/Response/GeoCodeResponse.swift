//
//  GeocodeResponse.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct GeocodeResponse: APIResponse {
    let meta: Meta
    let documents: [AddressSet]

    struct AddressSet: Codable {
        let regionType, addressName, region1DepthName, region2DepthName: String
        let region3DepthName, region4DepthName, code: String
        let xCoordinate, yCoordinate: Double

        enum CodingKeys: String, CodingKey {
            case regionType = "region_type"
            case addressName = "address_name"
            case region1DepthName = "region_1depth_name"
            case region2DepthName = "region_2depth_name"
            case region3DepthName = "region_3depth_name"
            case region4DepthName = "region_4depth_name"
            case code
            case xCoordinate = "x"
            case yCoordinate = "y"
        }
    }

    struct Meta: Codable {
        let totalCount: Int

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
        }
    }
}

extension LocationInfo {
    init?(geocodeAddress: GeocodeResponse.AddressSet) {
        self.identifier = UUID()
        self.longtitude = geocodeAddress.xCoordinate
        self.latitude = geocodeAddress.yCoordinate
        self.address = Address(
            fullAddress: geocodeAddress.addressName,
            firstRegion: geocodeAddress.region1DepthName,
            secondRegion: geocodeAddress.region2DepthName,
            thirdRegion: geocodeAddress.region3DepthName,
            fourthRegion: geocodeAddress.region4DepthName
        )
    }
}
