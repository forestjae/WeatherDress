//
//  PageSceneCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/12.
//

import Foundation
import UIKit
import RxSwift

final class MainCoordinator: Coordinator<Void> {
    private let parentViewController: UIViewController
    private let navigationController: UINavigationController
    private let mainViewController: MainViewController

    private let animated: Bool
    private let index: Int

    init(index: Int, parentViewController: UIViewController, animated: Bool) {
        self.parentViewController = parentViewController
        self.navigationController = UINavigationController()
        self.mainViewController = MainViewController()
        self.animated = animated
        self.index = index
    }

    override func start() -> Observable<Void> {
        guard let database = RealmService.shared else {
            return Observable.never()
        }

        let viewModel = MainViewModel(
            useCase: DefaultLocationUseCase(
                repository: DefaultLocationRepository(
                    apiService: GeoSearchService(
                        apiProvider: DefaultAPIProvider()
                    ),
                    database: database)
            ),
            coordinator: self, index: index
        )

        self.mainViewController.viewModel = viewModel
        self.navigationController.setViewControllers([self.mainViewController], animated: false)
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve

        self.parentViewController.present(navigationController, animated: self.animated)

        let dismiss = viewModel.dismiss

        return dismiss
            .do(onNext: { _ in
                self.mainViewController.dismiss(animated: true, completion: nil)
            })
    }

    func coordinateToUserSetting() -> Observable<Void> {
        return self.coordinate(
            to: UserSettingCoordinator(
                navigationController: self.navigationController
            )
        )
    }

    func setCurrentLocationWeatherViewController(with location: LocationInfo, isVisible: Bool) {
        let viewController = self.makeWeatherViewController(with: location)

        viewController.view.tag = 0
        if isVisible {
            self.mainViewController.orderedViewControllers[0] = viewController
        } else {
            self.mainViewController.orderedViewControllers.forEach { $0.view.tag += 1 }
            self.mainViewController.orderedViewControllers.insert(viewController, at: 0)
        }
        self.mainViewController.setCurrentPageViewController(at: 0)
    }

    func deleteCurrentLocationWeatherViewController() {
        let currentOrdered = self.mainViewController.orderedViewControllers.enumerated()
            .filter { index, _ in index != 0 }
            .map { $0.1 }
        self.mainViewController.orderedViewControllers = currentOrdered
        self.mainViewController.orderedViewControllers.forEach { $0.view.tag -= 1 }
        self.mainViewController.setCurrentPageViewController(at: 0)
    }

    func setChildViewController(with locations: [LocationInfo], isCurrentVisible: Bool) {
        let childCount = self.mainViewController.orderedViewControllers.count
        let targetCount = isCurrentVisible ? locations.count + 1 : locations.count

        if (childCount == 1 && isCurrentVisible) || childCount == 0 {
            if locations.count == 0 {
                return
            }
            self.mainViewController.orderedViewControllers.append(contentsOf: locations.enumerated()
                .map { index, location in
                    let viewController = self.makeWeatherViewController(with: location)
                    viewController.view.tag = index + targetCount - locations.count
                    return viewController
                })
            self.mainViewController.setCurrentPageViewController(at: index)
        }
    }

    private func makeWeatherViewController(with location: LocationInfo) -> WeatherClothingViewController {
        let weatherViewController = WeatherClothingViewController()
        let weatherCoordinator = WeatherClothingCoordinator(viewController: weatherViewController)
        let viewModel = WeatherClothingViewModel(
            coordinator: weatherCoordinator,
            useCase: DefaultWeatherUseCase(
                repository: DefaultWeatherRepository(
                    apiService: WeatherService(
                        apiProvider: DefaultAPIProvider()
                    )
                )
            ),
            clothingUseCase: DefaultClothesUseCase(repository: DefaultClothesRepository()),
            userSettingUseCase: DefaultUserSetttingUseCase(repository: DefaultUserSettingRepository()),
            location: location
        )

        weatherViewController.viewModel = viewModel
        return weatherViewController
    }
}
