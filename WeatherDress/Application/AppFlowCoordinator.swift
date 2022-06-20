//
//  AppFlowCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/12.
//

import UIKit
import RxSwift

final class AppFlowCoordinator: Coordinator<Void> {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if UserDefaults.standard.string(forKey: "Gender") == nil {
            return self.initialSettingFlow(navigationController: navigationController)
        }

        return self.mainViewFlow(navigationController: navigationController)
    }

    private func mainViewFlow(navigationController: UINavigationController) -> Observable<Void> {
        let pageSceneCoordinator = MainCoordinator(navigationController: navigationController)
        return self.coordinate(to: pageSceneCoordinator)
    }

    private func initialSettingFlow(
        navigationController: UINavigationController
    ) -> Observable<Void> {
        let initialSettingCoordinator = InitialSettingCoordinator(
            parentViewController: navigationController
        )

        return self.coordinate(to: initialSettingCoordinator)
    }
}
