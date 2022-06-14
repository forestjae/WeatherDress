//
//  PageSceneCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/12.
//

import Foundation
import UIKit
import RxSwift

class PageSceneCoordinator: Coordinator<Void> {

    private let navigationController: UINavigationController
    private let mainViewController: MainViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
    }

    override func start() -> Observable<Void> {
        guard let database = RealmService.shared else {
            return Observable.never()
        }

        let viewModel = MainViewModel(
            useCase: LocationUseCase(
                repository: DefaultLocationRepository(
                    apiService: GeoSearchService(
                        apiProvider: DefaultAPIProvider()
                    ),
                    database: database)
            ),
            coordinator: self
        )
        self.mainViewController.viewModel = viewModel
        self.navigationController.setViewControllers([self.mainViewController], animated: true)

        return Observable.never()
    }

    func coordinateToLocationList() -> Observable<Int> {
        return self.coordinate(
            to: LocationListCoordinator(
                parentViewController:
                    self.navigationController
            )
        )
            .map { result in
                switch result {
                case .cellDidTap(let index):
                    return index
                }
            }
    }

    func coordinateToUserSetting() -> Observable<Void> {
        return self.coordinate(
            to: UserSettingCoordinator(
                parentViewController: self.navigationController
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
            self.mainViewController.setCurrentPageViewController(at: 0)
        } else if childCount < targetCount {
            guard let last = locations.last else {
                return
            }
            let viewController = self.makeWeatherViewController(with: last)
            viewController.view.tag = targetCount - 1
            self.mainViewController.orderedViewControllers.append(viewController)
            self.mainViewController.setCurrentPageViewController(at: 0)
        } else if childCount > targetCount {
            let favoriteViewController: [WeatherViewController]
            if isCurrentVisible {
                favoriteViewController = Array(self.mainViewController.orderedViewControllers.dropFirst())
            } else {
                favoriteViewController = self.mainViewController.orderedViewControllers
            }

            zip(favoriteViewController, locations).forEach { viewController, location in
                viewController.viewModel?.setLocationInfo(location)
            }

            self.mainViewController.orderedViewControllers.remove(at: targetCount)
            if self.mainViewController.orderedViewControllers.count > 0 {
                self.mainViewController.setCurrentPageViewController(at: 0)
            }
        }
    }

    private func makeWeatherViewController(with location: LocationInfo) -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        let weatherCoordinator = WeatherCoordinator(viewController: weatherViewController)
        let viewModel = WeatherViewModel(
            coordinator: weatherCoordinator,
            useCase: WeatherUseCase(
                repository: DefaultWeatherRepository(
                    apiService: WeatherService(
                        apiProvider: DefaultAPIProvider()
                    )
                )
            ),
            clothingUseCase: ClothesUseCase(repository: DefaultClothesRepository()),
            location: location
        )

        weatherViewController.viewModel = viewModel
        return weatherViewController
    }
}
