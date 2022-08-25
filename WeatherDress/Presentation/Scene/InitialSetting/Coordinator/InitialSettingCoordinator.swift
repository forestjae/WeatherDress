//
//  InitialSettingCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/26.
//

import UIKit
import RxSwift

final class InitialSettingCoordinator: Coordinator<Void> {
    private let parentViewController: UINavigationController

    init(parentViewController: UINavigationController) {
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
        self.parentViewController.pushViewController(initialSettingViewController, animated: true)
        self.parentViewController.isNavigationBarHidden = true

        let accept = initialSettingViewModel.acceptButtonDidTap

        return accept
            .flatMap {
                self.mainViewFlow(navigationController: self.parentViewController)
            }
    }

    private func mainViewFlow(navigationController: UINavigationController) -> Observable<Void> {
        let pageSceneCoordinator = MainCoordinator(navigationController: navigationController)
        return self.coordinate(to: pageSceneCoordinator)
    }

}
