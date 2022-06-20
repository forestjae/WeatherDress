//
//  UltraShortNowcastRequest.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/03.
//

import Foundation

struct UltraShortNowcastRequest: ShortForecastRequestable {
    typealias Response = UltraShortNowcastWeatherResponse

    let path: String = "getUltraSrtNcst"
    let headers: [String: String]? = nil
    let method: HTTPMethod = .get
    let pageNo: Int = 1
    let numOfRows: Int = 1000
    let baseDate: Date
    let dataType = "JSON"
    let xAxisNumber: Int
    let yAxisNumber: Int
    let serviceKey: String

    var parameters: [String: String] {
        [
            "pageNo": String(self.pageNo),
            "numOfRows": String(self.numOfRows),
            "base_time": self.baseDate.convert(to: DateFormatter.ultraShortNowcastTime),
            "base_date": self.baseDate.convert(to: DateFormatter.requestableDate),
            "dataType": self.dataType,
            "nx": String(self.xAxisNumber),
            "ny": String(self.yAxisNumber),
            "serviceKey": self.serviceKey
        ]
    }
}
