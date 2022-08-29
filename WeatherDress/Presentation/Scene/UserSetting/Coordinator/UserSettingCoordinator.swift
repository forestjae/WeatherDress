//
//  UserSettingCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

final class UserSettingCoordinator: Coordinator<Void> {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Observable<Void> {
        let userSettingViewController = UserSettingViewController()
        let userSettingRepository = DefaultUserSettingRepository()
        let userSettingUseCase = DefaultUserSetttingUseCase(repository: userSettingRepository)
        let userSettingViewModel = UserSettingViewModel(
            useCase: userSettingUseCase,
            coordinator: self
        )

        userSettingViewController.viewModel = userSettingViewModel

        self.navigationController.pushViewController(
            userSettingViewController, animated: true
        )

        self.navigationController.setNavigationBarHidden(
            false,
            animated: true
        )

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .moderateSky
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController.navigationBar.standardAppearance = appearance
            self.navigationController.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController.navigationBar.barTintColor = .moderateSky
            self.navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }

        userSettingViewController.navigationController?.navigationBar.barTintColor = .blue

        let backBarButtonDidTap = userSettingViewModel.backBarButtonDidTap

        return backBarButtonDidTap
            .do(onNext: {
                self.navigationController.isNavigationBarHidden = true
                self.navigationController.popViewController(animated: true)
            })
    }
}
