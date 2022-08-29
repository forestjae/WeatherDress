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

    private weak var coordinator: InitialSettingCoordinator!
    private let userSettingUseCase: DefaultUserSetttingUseCase
    private let _accept = PublishSubject<Void>()

    init(
        useCase: DefaultUserSetttingUseCase,
        coordinator: InitialSettingCoordinator
    ) {
        self.userSettingUseCase = useCase
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
        let userSettingDone: Observable<Void>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let list = [Int](5...23)
            .map { DateFormatter.yearMonthDay.string(from: Date()) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)} +
            [Int](0...4)
            .map { DateFormatter.yearMonthDay.string(from: Date() + 3600 * 24) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)}

        let leaveTimeDateSource = Array(list.prefix(23))

        let returnTimeDateSource = Array(list.suffix(23))

        let leaveTimeDates = Driver.of(leaveTimeDateSource)
        let returnTimeDates = Driver.of(returnTimeDateSource)

        let initialLeaveTimeDate = Driver.just(3)
        let initialReturnTimeDate = Driver.just(12)

        let leaveTime = Observable.merge(
            input.leaveTime.asObservable(),
            Observable.just(leaveTimeDateSource[3])
        )

        let returnTime = Observable.merge(
            input.returnTime.asObservable(),
            Observable.just(returnTimeDateSource[12])
        )

        let selectedGender = input.genderSegmentedIndex
            .asObservable()
            .compactMap { Gender(index: $0) }

        let selectedTemperatureSensitive = input.temperatureSensitiveSegmentedIndex
            .asObservable()
            .compactMap { TemperatureSensitiveness(rawValue: $0) }

        let currentSetting = Observable.combineLatest(
            selectedGender,
            selectedTemperatureSensitive,
            leaveTime,
            returnTime
        )

        let isAcceptable = Observable.combineLatest(leaveTime, returnTime)
            .map { leaveTime, returnTime in
                leaveTime + 3600 <= returnTime
            }
            .asDriver(onErrorJustReturn: false)

        let settingDone = input.acceptButtonDidTap
            .withLatestFrom(currentSetting)
            .do(onNext: { [weak self] gender, temperatureSensitive, leaveTime, returnTime in
                self?.userSettingUseCase.setUserGender(for: gender)
                self?.userSettingUseCase.setUserTemperatureSensitive(for: temperatureSensitive)
                self?.userSettingUseCase.setUserLeaveTime(for: leaveTime.convert(to: .leaveReturnTime))
                self?.userSettingUseCase.setUserReturnTime(for: returnTime.convert(to: .leaveReturnTime))
                self?.userSettingUseCase.setUserInitialSettingDone()
                self?._accept.onNext(())
            })
            .map { _ in }

        return Output(
            leaveTimeDates: leaveTimeDates,
            returnTimeDates: returnTimeDates,
            initialLeaveTimeDate: initialLeaveTimeDate,
            initialReturnTimeDate: initialReturnTimeDate,
            isAcceptable: isAcceptable,
            userSettingDone: settingDone
        )
    }
}
