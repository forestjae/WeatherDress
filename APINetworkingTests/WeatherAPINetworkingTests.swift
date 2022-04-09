//
//  APINetworkingTests.swift
//  APINetworkingTests
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import XCTest
@testable import WeatherDress

class WeatherAPINetworkingTests: XCTestCase {
    let apiProvider = DefaultAPIProvider()

    func test_초단기실황_request() {
        let expectation = XCTestExpectation()
        let request = ShortForecastRequest(
            function: .ultraShortNowcast,
            xAxisNumber: 55,
            yAxisNumber: 127,
            serviceKey: Bundle.main.weatherApiKey
        )

        self.apiProvider.request(request) { result in
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

    func test_단기예보_request() {
        let expectation = XCTestExpectation()
        let request = ShortForecastRequest(
            function: .shortForecast,
            xAxisNumber: 55,
            yAxisNumber: 127,
            serviceKey: Bundle.main.weatherApiKey
        )

        self.apiProvider.request(request) { result in
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

    func test_초단기예보_request() {
        let expectation = XCTestExpectation()
        let request = ShortForecastRequest(
            function: .ultraShortForecast,
            xAxisNumber: 121,
            yAxisNumber: 61,
            serviceKey: Bundle.main.weatherApiKey
        )
        self.apiProvider.request(request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(UltraShortForecastWeatherResponse.self, from: data)
                    let items = decoded.response.body.items.item
                    let result = UltraShortForecastWeatherList(items: items)
                    print(result)
                    XCTAssert(result.forecastList.count != 0)
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

    func test_중기전망예보_request() {
        let expectation = XCTestExpectation()
        let request = MidForecastRequest(
            function: .midLandForecast,
            regionIdentification: "11B00000",
            serviceKey: Bundle.main.weatherApiKey
        )
        self.apiProvider.request(request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(MidForecastWeatherResponse.self, from: data)
                    let items = decoded.response.body.items.item
                    print(items)
                } catch let error {
                    XCTFail("파싱 에러")
                }
            case .failure:
                XCTFail("통신 에러")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_중기기온예보_request() {
        let expectation = XCTestExpectation()
        let request = MidForecastRequest(
            function: .midTemperatureForecast,
            regionIdentification: "11B10101",
            serviceKey: Bundle.main.weatherApiKey
        )
        self.apiProvider.request(request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(MidForecastTemperatureResponse.self, from: data)
                    let items = decoded.response.body.items.item
                    print(items)
                } catch let error {
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
