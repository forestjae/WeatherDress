//
//  GeoSearchAPINetworkingTests.swift
//  APINetworkingTests
//
//  Created by Lee Seung-Jae on 2022/04/07.
//

import XCTest
@testable import WeatherDress

class GeoSearchAPINetworkingTests: XCTestCase {
    let apiProvider = DefaultAPIProvider()
    lazy var service = GeoSearchService(apiProvider: self.apiProvider)

    func test_geocode_request() {
        let expectation = XCTestExpectation()
        let request = GeocodeRequest(
            function: .geocode,
            xCoordinate: 127.0493384,
            yCoordinate: 37.2387141
        )
        self.apiProvider.request(request) { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            case .failure:
                XCTFail("통신 실패")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_addressSearch_request() {
        let expectation = XCTestExpectation()
        let request = AddressSearchRequest(function: .addressSearch, query: "수원시")
        self.apiProvider.request(request) { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            case .failure:
                XCTFail("통신 실패")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
