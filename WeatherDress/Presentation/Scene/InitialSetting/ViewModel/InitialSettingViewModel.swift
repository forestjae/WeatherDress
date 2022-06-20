//
//  InitialSettingViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/26.
//

import Foundation
import RxSwift
import RxCocoa

final class InitialSettingViewModel {
    let acceptButtonDidTap: Observable<Void>

    private let coordinator: InitialSettingCoordinator
    private let useCase: UserSetttingUseCase
    private let _accept = PublishSubject<Void>()

    init(
        useCase: UserSetttingUseCase,
        coordinator: InitialSettingCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.acceptButtonDidTap = self._accept.asObservable()
    }

    struct Input {
        let genderSegmentedIndex: BehaviorRelay<Int>
        let temperatureSensitiveSegmentedIndex: BehaviorRelay<Int>
        let leaveTime: BehaviorRelay<Date>
        let returnTime: BehaviorRelay<Date>
        let acceptButtonDidTap: Observable<Void>
    }

    struct Output {
        let leaveTimeDates: Driver<[Date]>
        let returnTimeDates: Driver<[Date]>
        let initialLeaveTimeDate: Driver<Int>
        let initialReturnTimeDate: Driver<Int>
        let isAcceptable: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let acceptButtonDidTapped = input.acceptButtonDidTap

        acceptButtonDidTapped
            .subscribe(self._accept)
            .disposed(by: disposeBag)

        let list = [Int](5...23)
            .map { DateFormatter.yearMonthDay.string(from: Date()) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)} +
            [Int](0...4)
            .map { DateFormatter.yearMonthDay.string(from: Date() + 3600 * 24) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)}

        let leaveTimeDateSource = Array(list.prefix(23))

        let returnTImeDateSource = Array(list.suffix(23))

        let leaveTimeDates = Driver.of(leaveTimeDateSource)
        let returnTimeDates = Driver.of(returnTImeDateSource)

        let initialLeaveTimeDate = Driver.just(3)
        let initialReturnTimeDate = Driver.just(12)

        let leaveTime = Driver.merge(
            input.leaveTime.asDriver(),
            Driver.just(leaveTimeDateSource[3])
        )
        let returnTime = Driver.merge(
            input.returnTime.asDriver(),
            Driver.just(returnTImeDateSource[12])
        )
        let selectedGender = input.genderSegmentedIndex
            .asObservable()
            .compactMap { Gender(index: $0) }

        let selectedTemperatureSensitive = input.temperatureSensitiveSegmentedIndex
            .asObservable()
            .compactMap { TemperatureSensitiveness(rawValue: $0) }

        _ = acceptButtonDidTapped.withLatestFrom(selectedGender)
            .do(onNext: { [weak self] gender in
                self?.useCase.setUserGender(for: gender)
            })
            .compactMap { $0.rawValue }
            .subscribe()

        _ = acceptButtonDidTapped.withLatestFrom(selectedTemperatureSensitive)
            .do(onNext: { [weak self] temperatureSensitive in
                self?.useCase.setUserTemperatureSensitive(for: temperatureSensitive)
            })
            .subscribe()

        _ = acceptButtonDidTapped.withLatestFrom(leaveTime)
            .map { $0.convert(to: .leaveReturnTime) }
            .do(onNext: { [weak self] leaveTime in
                self?.useCase.setUserLeaveTime(for: leaveTime)
            }).subscribe()

        _ = acceptButtonDidTapped.withLatestFrom(returnTime)
            .map { $0.convert(to: .leaveReturnTime) }
            .do(onNext: { [weak self] returnTime in
                self?.useCase.setUserReturnTime(for: returnTime)
            }).subscribe()

        let isAcceptable = Driver.combineLatest(leaveTime, returnTime)
            .map { leaveTime, returnTime in
                leaveTime + 3600 <= returnTime
            }

        return Output(
            leaveTimeDates: leaveTimeDates,
            returnTimeDates: returnTimeDates,
            initialLeaveTimeDate: initialLeaveTimeDate,
            initialReturnTimeDate: initialReturnTimeDate,
            isAcceptable: isAcceptable
        )
    }
}
