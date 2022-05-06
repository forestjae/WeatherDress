//
//  AppFlowCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/12.
//

import Foundation
import UIKit
import RxSwift

class AppFlowCoordinator: Coordinator<Void> {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        let pageSceneCoordinator = PageSceneCoordinator(navigationController: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return self.coordinate(to: pageSceneCoordinator)
    }
}
