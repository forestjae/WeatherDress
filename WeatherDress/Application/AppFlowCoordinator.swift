//
//  AppFlowCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/12.
//

import UIKit
import RxSwift

final class AppFlowCoordinator: Coordinator<Void> {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let navigationController = UINavigationController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        guard UserDefaults.standard.bool(forKey: "InitialSettingDone") == true else {
            return self.coordinateToInitialSettingFlow(parentViewController: navigationController)
                .flatMap { _ in
                    self.coordinateToLocationSceneFlow(navigationController: navigationController)
                }
        }

        return self.coordinateToLocationSceneFlow(navigationController: navigationController)
    }

    private func coordinateToLocationSceneFlow(
        navigationController: UINavigationController
    ) -> Observable<Void> {
        let locationSceneCoordinator = LocationListCoordinator(
            navigationViewController: navigationController
        )

        return self.coordinate(to: locationSceneCoordinator)
    }

    private func coordinateToInitialSettingFlow(
        parentViewController: UINavigationController
    ) -> Observable<Void> {
        let initialSettingCoordinator = InitialSettingCoordinator(
            parentViewController: parentViewController
        )

        return self.coordinate(to: initialSettingCoordinator)
    }
}
