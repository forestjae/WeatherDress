//
//  TimeConfigurationCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

class TimeConfigurationCoordinator: Coordinator<TimeConfigurationDismissAction> {

    private let parentViewController: UIViewController
    private let initialLeaveReturnTime: (Date, Date)

    init(parentViewController: UIViewController, for leaveReturnTime: (Date, Date)) {
        self.parentViewController = parentViewController
        self.initialLeaveReturnTime = leaveReturnTime
    }

    override func start() -> Observable<TimeConfigurationDismissAction> {
        let timeConfigurationViewController = TimeConfigurationViewController()
        let userSettingRepository = DefaultUserSettingRepository()
        let userSettingUseCase = UserSetttingUseCase(repository: userSettingRepository)
        let timeConfigurationViewModel = TimeConfigurationViewModel(
            useCase: userSettingUseCase,
            coordinator: self, initialDate: self.initialLeaveReturnTime
        )

        timeConfigurationViewController.viewModel = timeConfigurationViewModel

        timeConfigurationViewController.modalPresentationStyle = .overFullScreen
        timeConfigurationViewController.modalTransitionStyle = .crossDissolve

        self.parentViewController.present(
            timeConfigurationViewController,
            animated: true,
            completion: nil
        )

        let accept = timeConfigurationViewModel.accept
            .map { TimeConfigurationDismissAction.accept(leaveTime: $0.0, returnTime: $0.1)}

        let cancel = timeConfigurationViewModel.cancel
            .map { TimeConfigurationDismissAction.cancel }
            .debug()

        return Observable.merge(accept, cancel)
            .take(1)
            .do(onNext: { _ in
                timeConfigurationViewController.dismiss(animated: true, completion: nil)
            })
    }
}

enum TimeConfigurationDismissAction {
    case cancel
    case accept(leaveTime: Date, returnTime: Date)
}
