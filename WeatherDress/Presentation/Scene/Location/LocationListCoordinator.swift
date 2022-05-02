//
//  LocationListCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/16.
//

import Foundation
import UIKit
import RxSwift

class LocationListCoordinator: Coordinator<LocationListDismissAction> {
    
    private let parentViewController: UIViewController

    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }

    override func start() -> Observable<LocationListDismissAction> {
        let locationListViewController = LocationViewController()
        let locationListViewModel = LocationViewModel(
            useCase: LocationUseCase(
                repository: sharedRepo
            ), coordinator: self
        )
        locationListViewController.viewModel = locationListViewModel
        let navigationController = UINavigationController(rootViewController: locationListViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        self.parentViewController.present(navigationController, animated: true, completion: nil)

        let locationResult = locationListViewModel.locationListCellDidTap
            .map { LocationListDismissAction.cellDidTap(index: $0) }

        return locationResult
            .take(1)
            .do(onNext: { _ in
                locationListViewController.dismiss(animated: true, completion: nil)
            })
    }
}

enum LocationListDismissAction {
    case cellDidTap(index: Int)
}