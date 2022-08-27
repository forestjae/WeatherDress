//
//  InitialSettingCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/26.
//

import UIKit
import RxSwift

final class InitialSettingCoordinator: Coordinator<Void> {
    private let parentViewController: UIViewController

    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }

    override func start() -> Observable<Void> {
        let initialSettingViewController = InitialSettingViewController()
        let userSettingRepository = DefaultUserSettingRepository()
        let userSettingUseCase = DefaultUserSetttingUseCase(repository: userSettingRepository)
        let initialSettingViewModel = InitialSettingViewModel(
            useCase: userSettingUseCase,
            coordinator: self
        )

        initialSettingViewController.viewModel = initialSettingViewModel
        initialSettingViewController.modalPresentationStyle = .fullScreen

        self.parentViewController.present(initialSettingViewController, animated: false)

        let accept = initialSettingViewModel.acceptButtonDidTap

        return accept
            .do(onNext: {
                initialSettingViewController.dismiss(animated: true)
            })
    }
}
