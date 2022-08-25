//
//  UserSettingCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

final class UserSettingCoordinator: Coordinator<Void> {

    private let parentViewController: UINavigationController

    init(parentViewController: UINavigationController) {
        self.parentViewController = parentViewController
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

        self.parentViewController.pushViewController(userSettingViewController, animated: true)
        self.parentViewController.setNavigationBarHidden(false, animated: true)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .moderateSky
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.parentViewController.navigationBar.standardAppearance = appearance
            self.parentViewController.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.parentViewController.navigationBar.barTintColor = .moderateSky
            self.parentViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }

        userSettingViewController.navigationController?.navigationBar.barTintColor = .blue

        let backBarButtonDidTap = userSettingViewModel.backBarButtonDidTap

        return backBarButtonDidTap
            .do(onNext: {
                self.parentViewController.isNavigationBarHidden = true
                self.parentViewController.popViewController(animated: true)
            })
    }
}
