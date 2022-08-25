//
//  UserSettingViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import Foundation
import RxSwift
import RxCocoa

final class UserSettingViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let genderSegmentedIndex: BehaviorRelay<Int>
        let temperatureSensitiveSegmentedIndex: BehaviorRelay<Int>
        let leaveTime: BehaviorRelay<Date>
        let returnTime: BehaviorRelay<Date>
        let backBarButtonDidTap: Observable<Void>
    }

    struct Output {
        let setGender: Driver<Int>
        let setTemperatureSensitive: Driver<Int>
        let setLeaveTimePickerDate: Driver<String>
        let setReturnTimePickerDate: Driver<String>
        let initialLeaveTimePickerIndex: Observable<Int>
        let initialReturnTimePickerIndex: Observable<Int>
        let leaveTimeDates: Driver<[Date]>
        let returnTimeDates: Driver<[Date]>
        let isAcceptable: Driver<Bool>
    }

    let backBarButtonDidTap: Observable<Void>

    private let coordinator: UserSettingCoordinator
    private let useCase: DefaultUserSetttingUseCase
    private let _backBarButtonDidTap = PublishSubject<Void>()

    init(
        useCase: DefaultUserSetttingUseCase,
        coordinator: UserSettingCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.backBarButtonDidTap = self._backBarButtonDidTap.asObservable()
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let backBarButtonDIdTap = input.backBarButtonDidTap
            .subscribe(self._backBarButtonDidTap)
            .disposed(by: disposeBag)

        let list = [Int](5...23)
            .map { DateFormatter.yearMonthDay.string(from: Date()) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)} +
            [Int](0...4)
            .map { DateFormatter.yearMonthDay.string(from: Date() + 3600 * 24) + String(format: "%02d", $0) }
            .compactMap { DateFormatter.yearMonthDayHour.date(from: $0)}

        let leaveTimeDateSource = Array(list.prefix(23))

        let returnTimeDateSource = Array(list.suffix(23))

        let leaveTimeDate = Driver.of(leaveTimeDateSource)
        let returnTimeDate = Driver.of(returnTimeDateSource)

        let configuredLeaveTime = input.leaveTime
            .skip(1)
            .share()
        let configuredReturnTime = input.returnTime
            .skip(1)
            .share()

        let initialLeaveTime = input.viewWillAppear
            .flatMap { self.useCase.getUserLeaveTime() }
            .compactMap { $0?.convertToDate() }
            .take(1)
            .share()

        let initialLeaveTimePickerIndex = initialLeaveTime
            .compactMap { leaveTimeDateSource.firstIndex(of: $0) }

        let initialReturnTime = input.viewWillAppear
            .flatMap { self.useCase.getUserReturnTime() }
            .compactMap { $0?.convertToDate() }
            .take(1)
            .share()

        let initialReturnTimePickerIndex = initialReturnTime
            .compactMap { returnTimeDateSource.firstIndex(of: $0)}

        let initialGender = self.useCase.getUserGender()
            .take(1)
            .compactMap { $0 }

        let initialTemperatureSensitive = self.useCase.getUserTemperatureSensitive()
            .take(1)
            .compactMap { $0 }

        let leaveTime = Observable.merge(
            initialLeaveTime,
            configuredLeaveTime
        )
            .distinctUntilChanged()
            .share()

        let returnTime = Observable.merge(
            initialReturnTime,
            configuredReturnTime
        )
            .distinctUntilChanged()
            .share()

        let isAcceptable = Observable.combineLatest(leaveTime, returnTime)
            .skip(1)
            .map { leaveTime, returnTime in
                leaveTime + 3600 <= returnTime
            }

            .share()

        let setLeaveTime = Observable.zip(isAcceptable, configuredLeaveTime)
            .filter { $0.0 }
            .map { $0.1.convert(to: .leaveReturnTime) }
            .do(onNext: { [weak self] leaveTime in
                self?.useCase.setUserLeaveTime(for: leaveTime)
            })
            .asDriver(onErrorJustReturn: "")

        let setReturnTime = Observable.zip(isAcceptable, configuredReturnTime)
            .filter { $0.0 }
            .map { $0.1.convert(to: .leaveReturnTime) }
            .do(onNext: { [weak self] returnTime in
                self?.useCase.setUserReturnTime(for: returnTime)
            })
            .asDriver(onErrorJustReturn: "")

        let selectedGender = input.genderSegmentedIndex.asObservable()
                .compactMap { Gender(index: $0) }

        let setGender = Observable.merge(initialGender, selectedGender)
            .do(onNext: { [weak self] gender in
                self?.useCase.setUserGender(for: gender)
            })
            .compactMap { $0.index }
            .asDriver(onErrorJustReturn: 0)

        let selectedTemperatureSensitive = input.temperatureSensitiveSegmentedIndex
            .asObservable()
            .compactMap { TemperatureSensitiveness(rawValue: $0) }

        let setTemperatureSensitive = Observable.merge(
            initialTemperatureSensitive, selectedTemperatureSensitive
        )
            .do(onNext: { [weak self] temperatureSensitive in
                self?.useCase.setUserTemperatureSensitive(for: temperatureSensitive)
            })
            .compactMap { $0.rawValue }
            .asDriver(onErrorJustReturn: 1)

        return Output(
            setGender: setGender,
            setTemperatureSensitive: setTemperatureSensitive,
            setLeaveTimePickerDate: setLeaveTime,
            setReturnTimePickerDate: setReturnTime,
            initialLeaveTimePickerIndex: initialLeaveTimePickerIndex,
            initialReturnTimePickerIndex: initialReturnTimePickerIndex,
            leaveTimeDates: leaveTimeDate,
            returnTimeDates: returnTimeDate,
            isAcceptable: isAcceptable.asDriver(onErrorJustReturn: false)
        )
    }
}
