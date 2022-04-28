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
        self.mainViewController = navigationController.viewControllers[0] as! MainViewController
        let viewModel = MainViewModel(
            useCase: LocationUseCase(repository: sharedRepo))
        mainViewController.viewModel = viewModel
    }

    override func start() -> Observable<Void> {

        guard let viewModel = self.mainViewController.viewModel else {
            return Observable.never()
        }

        viewModel.locations
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let viewControllerCount = self.mainViewController.orderedViewControllers.count
                if  viewControllerCount == 0 {
                    self.mainViewController.orderedViewControllers = $0.enumerated().map { index, lc in
                        let vc = self.makeWeatherViewController(with: lc)
                        vc.view.tag = index
                        return vc
                    }

                    self.mainViewController.setCurrentPageViewController(at: 0)
                } else if viewControllerCount < $0.count {
                    guard let last = $0.last else {
                        return
                    }
                    let vc = self.makeWeatherViewController(with: last)
                    vc.view.tag = $0.count - 1

                    self.mainViewController.orderedViewControllers.append(vc)
                    self.mainViewController.setCurrentPageViewController(at: 0)
                } else if viewControllerCount > $0.count {
                    zip(self.mainViewController.orderedViewControllers, $0)
                    .forEach { vc, location in
                        vc.viewModel?.setLocationInfo(location)
                    }

                    self.mainViewController.orderedViewControllers.remove(at: $0.count )
                    self.mainViewController.setCurrentPageViewController(at: 0)

                }
            })
            .disposed(by: self.disposeBag)

        viewModel.locationButtonDidTap
            .flatMap {
                self.coordinate(to: LocationListCoordinator(parentViewController: self.navigationController))
            }
            .subscribe(onNext: { result in
                switch result {
                case .cellDidTap(let index):
                    self.mainViewController.setCurrentPageViewController(at: index)
                }
            })
            .disposed(by: self.disposeBag)
        return Observable.never()
    }

    func makeWeatherViewController(with location: LocationInfo) -> WeatherViewController {
        let vm = WeatherViewModel(useCase: WeatherUseCase(repository: DefaultWeatherRepository(apiService: WeatherService(apiProvider: DefaultAPIProvider()))), location: location)
        let weatherViewController = WeatherViewController()
        weatherViewController.viewModel = vm
        return weatherViewController
    }
}
