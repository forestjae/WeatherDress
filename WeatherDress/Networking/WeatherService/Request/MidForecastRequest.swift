//
//  MidForecastRequest.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/06.
//

import Foundation

struct MidForecastRequest: MidForecastRequestable {
    let headers: [String : String]? = nil
    let function: MidForecastFunction
    let method: HTTPMethod = .get
    let baseDate = Date() - 3600 * 6 - 1
    let dataType = "JSON"
    let regionIdentification: String

    let serviceKey: String

    var parameters: [String: String] {
        [
            "dataType": self.dataType,
            "regId": self.regionIdentification,
            "tmFc": self.baseDate.convert(to: DateFormatter.midForecastRequestableTime),
            "serviceKey": self.serviceKey
        ]
    }
}
