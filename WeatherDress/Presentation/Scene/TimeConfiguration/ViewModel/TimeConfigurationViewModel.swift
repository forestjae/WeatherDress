//
//  TimeConfigurationViewModel.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import Foundation
import RxSwift
import RxCocoa

class TimeConfigurationViewModel {
    let accept: Observable<(Date, Date)>
    let cancel: Observable<Void>

    private let disposeBag = DisposeBag()
    private let coordinator: TimeConfigurationCoordinator
    private let _accept = PublishSubject<(Date, Date)>()
    private let _cancel = PublishSubject<Void>()
    private let initialDate = BehaviorSubject<(Date, Date)>(value: (Date(), Date()))

    init(
        useCase: UserSetttingUseCase,
        coordinator: TimeConfigurationCoordinator,
        initialDate: (Date, Date)
    ) {
        self.coordinator = coordinator
        self.accept = self._accept.asObservable()
        self.cancel = self._cancel.asObservable()
        self.initialDate.onNext(initialDate)
    }

    struct Input {
        let leaveTime: BehaviorRelay<Date>
        let returnTime: BehaviorRelay<Date>
        let acceptButtonDidTapped: Observable<Void>
        let cancelButtonDidTapped: Observable<Void>
    }

    struct Output {
        let leaveTimePickerDate: Driver<Date>
        let returnTimePickerDate: Driver<Date>
        let descriptionLabelTitle: Driver<String>
        let isAcceptable: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let initialLeaveTime = self.initialDate
            .map { $0.0 }

        let initialReturnTime = self.initialDate
            .map { $0.1 }

        let leaveTime = Observable.merge(
            initialLeaveTime,
            input.leaveTime.asObservable().skip(1)
        )
        let returnTime = Observable.merge(
            initialReturnTime,
            input.returnTime.asObservable().skip(1)
        )

        input.acceptButtonDidTapped
            .withLatestFrom(Observable.combineLatest(leaveTime, returnTime))
            .subscribe(self._accept)
            .disposed(by: disposeBag)

        input.cancelButtonDidTapped
            .subscribe(self._cancel)
            .disposed(by: disposeBag)

        let leaveReturnTime = Observable.combineLatest(leaveTime, returnTime).share()

        let descriptionLabelTitle = leaveReturnTime
            .map { leaveTime, returnTime in
                (DateFormatter.hourlyTime.string(from: leaveTime),
                DateFormatter.hourlyTime.string(from: returnTime))
            }
            .map { leaveTime, returnTime in
                "\(leaveTime)에 나갔다가 \(returnTime)에 돌아올래요"
            }
            .asDriver(onErrorJustReturn: "")
            .debug()

        let isAcceptable = leaveReturnTime
            .map { leaveTime, returnTime in
                leaveTime + 3600 <= returnTime
            }
            .asDriver(onErrorJustReturn: false)

        return Output(
            leaveTimePickerDate: initialLeaveTime.asDriver(onErrorJustReturn: Date()),
            returnTimePickerDate: initialReturnTime.asDriver(onErrorJustReturn: Date()),
            descriptionLabelTitle: descriptionLabelTitle,
            isAcceptable: isAcceptable
        )
    }
}
