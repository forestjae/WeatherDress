//
//  WeatherDressUseCaseTests.swift
//  WeatherDressUseCaseTests
//
//  Created by Lee Seung-Jae on 2022/05/11.
//

import XCTest
import RxSwift
import RxTest
import Nimble
import RxNimble

class ClothesUseCaseTests: XCTestCase {
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    var repository: ClothesRepository!

    override func setUpWithError() throws {
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.repository = MockClothesRepository()
    }

    func testClothes() {
        let clothes = self.repository.fetchCurrentRecommendedClothing(for: 0...10)
        expect(clothes).first.to(equal([]))
    }
}
