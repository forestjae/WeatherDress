//
//  InitialSettingViewModelTests.swift
//  WeatherDressViewModelTests
//
//  Created by Lee Seung-Jae on 2022/06/23.
//

import XCTest
import RxSwift
import RxTest
@testable import WeatherDress

class InitialSettingViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewModel: InitialSettingViewModel

    override func setUp() {
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
