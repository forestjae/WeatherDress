//
//  SceneDelegate.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppFlowCoordinator?

    private let disposeBag = DisposeBag()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        self.window = UIWindow(windowScene: windowScene)

        guard let window = window else {
            return
        }

        self.appCoordinator = AppFlowCoordinator(window: window)
        guard let appCoordinator = appCoordinator else {
            return
        }

        LocationManager.shared.authorizationStatus()
            .skip(1)
            .filter { $0 != .notDetermined}
            .take(1)
            .flatMap { status -> Observable<Void> in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse, .denied, .restricted:
                    return appCoordinator.start()
                default:
                    return Observable.never()
                }
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
