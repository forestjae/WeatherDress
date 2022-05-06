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
        let viewModel = MainViewModel(
            useCase: LocationUseCase(repository: sharedRepo), coordinator: self)
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

    func setChildViewController(with locations: [LocationInfo]) {
        let childCount = self.mainViewController.orderedViewControllers.count
        if  childCount == 0 {
            self.mainViewController.orderedViewControllers = locations.enumerated()
                .map { index, lc in
                    let vc = self.makeWeatherViewController(with: lc)
                    vc.view.tag = index
                    return vc
                }

            self.mainViewController.setCurrentPageViewController(at: 0)
        } else if childCount < locations.count {
            guard let last = locations.last else {
                return
            }
            let vc = self.makeWeatherViewController(with: last)
            vc.view.tag = locations.count - 1

            self.mainViewController.orderedViewControllers.append(vc)
            self.mainViewController.setCurrentPageViewController(at: 0)
        } else if childCount > locations.count {
            zip(self.mainViewController.orderedViewControllers, locations)
            .forEach { vc, location in
                vc.viewModel?.setLocationInfo(location)
            }

            self.mainViewController.orderedViewControllers.remove(at: locations.count)
            self.mainViewController.setCurrentPageViewController(at: 0)
        }
    }

    private func makeWeatherViewController(with location: LocationInfo) -> WeatherViewController {
        let viewModel = WeatherViewModel(
            useCase: WeatherUseCase(
                repository: DefaultWeatherRepository(
                    apiService: WeatherService(
                        apiProvider: DefaultAPIProvider()
                    )
                )
            ),
            location: location
        )
        let weatherViewController = WeatherViewController()
        weatherViewController.viewModel = viewModel
        return weatherViewController
    }
}
