//
//  APINetworkingTests.swift
//  APINetworkingTests
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import XCTest

class APINetworkingTests: XCTestCase {

    func testUSTWeatherRequest() {
        let expectation = XCTestExpectation()
        let request = ShortForecastRequest(
            function: .ultraShortNowcast,
            method: .get,
            pageNo: 1,
            numOfRows: 1000,
            baseTime: Date(timeIntervalSinceNow: -2400),
            baseDate: Date(),
            xAxisNumber: 55,
            yAxisNumber: 127,
            serviceKey: Bundle.main.apiKey
        )

        APIProvider().request(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(UltraShortNowcastWeatherResponse.self, from: data)
                    let weatherComponents = decoded.response.body?.items.item ?? []
                    let resultWeather = UltraShortNowcastWeatherItem(items: weatherComponents)
                    XCTAssertNotNil(resultWeather)
                } catch {
                    XCTFail("파싱 에러")
                }
            case .failure:
                XCTFail("통신 에러")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testSFWeatherRequest() {
        let expectation = XCTestExpectation()
        let request = ShortForecastRequest(
            function: .shortForecast,
            method: .get,
            pageNo: 1,
            numOfRows: 1000,
            baseTime: Date(timeIntervalSinceNow: -3200),
            baseDate: Date(),
            xAxisNumber: 55,
            yAxisNumber: 127,
            serviceKey: Bundle.main.apiKey
        )

        APIProvider().request(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(ShortForecastWeatherResponse.self, from: data)
                    let weatherItem = decoded.response.body.items.item
                    let list = ShortForecastWeatherList(items: weatherItem)
                    XCTAssertTrue(list.forecastList.count != 0)
                } catch {
                    XCTFail("파싱 에러")
                }

            case .failure:
                XCTFail("통신 에러")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

}
