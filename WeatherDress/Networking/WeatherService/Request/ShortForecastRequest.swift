//
//  ShortForecastRequest.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import Foundation

struct ShortForecastRequest: ShortForecastRequestable {
    let function: ShortForecastFunction
    let method: HTTPMethod

    let pageNo: Int
    let numOfRows: Int
    let baseTime: Date
    let baseDate: Date
    let dataType = "JSON"
    let xAxisNumber: Int
    let yAxisNumber: Int
    let serviceKey: String
    var parameters: [String: String] {
        [
            "pageNo": String(self.pageNo),
            "numOfRows": String(self.numOfRows),
            "base_time": self.baseTime.convert(to: DateFormatter.requestableTime),
            "base_date": self.baseDate.convert(to: DateFormatter.requestableDate),
            "dataType": self.dataType,
            "nx": String(self.xAxisNumber),
            "ny": String(self.yAxisNumber),
            "serviceKey": self.serviceKey
        ]
    }
}
