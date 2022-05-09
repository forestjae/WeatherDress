//
//  AddressSearchResponse.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import Foundation

struct AddressSearchResponse: APIResponse {
    let documents: [AddressSet]
    let meta: Meta

    struct AddressSet: Codable {
        let address: Address
        let addressName, addressType: String
        let xCoordinate, yCoordinate: String

        enum CodingKeys: String, CodingKey {
            case address
            case addressName = "address_name"
            case addressType = "address_type"
            case xCoordinate = "x"
            case yCoordinate = "y"
        }
    }

    struct Address: Codable {
        let addressName, bCode, hCode, mainAddressNo, mountainYn: String
        let region1DepthName, region2DepthName, region3DepthHName, region3DepthName: String
        let subAddressNo: String
        let xCoordinate, yCoordinate: String

        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case bCode = "b_code"
            case hCode = "h_code"
            case mainAddressNo = "main_address_no"
            case mountainYn = "mountain_yn"
            case region1DepthName = "region_1depth_name"
            case region2DepthName = "region_2depth_name"
            case region3DepthHName = "region_3depth_h_name"
            case region3DepthName = "region_3depth_name"
            case subAddressNo = "sub_address_no"
            case xCoordinate = "x"
            case yCoordinate = "y"
        }
    }

    struct Meta: Codable {
        let isEnd: Bool
        let pageableCount, totalCount: Int

        enum CodingKeys: String, CodingKey {
            case isEnd = "is_end"
            case pageableCount = "pageable_count"
            case totalCount = "total_count"
        }
    }
}
