//
//  LocationListCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/16.
//

import UIKit
import RxSwift

final class LocationListCoordinator: Coordinator<Void> {
    private let navigationController: UINavigationController
    private let locationViewController: LocationViewController

    init(navigationViewController: UINavigationController) {
        self.navigationController = navigationViewController
        let locationViewController = LocationViewController()
        self.locationViewController = locationViewController
    }

    override func start() -> Observable<Void> {
        guard let database = RealmService.shared else {
            return Observable.never()
        }

        let locationViewModel = LocationViewModel(
            useCase: DefaultLocationUseCase(
                repository: DefaultLocationRepository(
                    apiService: GeoSearchService(
                        apiProvider: DefaultAPIProvider()
                    ),
                    database: database)
            ),
            weatherUseCase: DefaultWeatherUseCase(
                repository: DefaultWeatherRepository(
                    apiService: WeatherService(apiProvider: DefaultAPIProvider())))
            ,
            coordinator: self
        )
        locationViewController.viewModel = locationViewModel

        self.navigationController.setViewControllers([locationViewController], animated: false)

        return self.coordinateToPageScene()
    }

    func coordinateToPageScene(index: Int = 0, animated: Bool = true) -> Observable<Void> {
        let pageSceneCoordinator = MainCoordinator(
            index: index,
            parentViewController: self.navigationController,
            animated: animated
        )
        return self.coordinate(to: pageSceneCoordinator)
    }
}
