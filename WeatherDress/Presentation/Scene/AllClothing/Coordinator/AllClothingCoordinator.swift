//
//  AllClothingCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

final class AllClothingCoordinator: Coordinator<Void> {

    private let parentViewController: UIViewController
    private let clothingItems: Observable<[ClothesItemViewModel]>

    init(
        parentViewController: UIViewController,
        for clothingItems: Observable<[ClothesItemViewModel]>
    ) {
        self.parentViewController = parentViewController
        self.clothingItems = clothingItems
    }

    override func start() -> Observable<Void> {
        let allClothingViewController = AllClothingViewController()
        let allClothingViewModel = AllClothingViewModel(coordinator: self, clothes: self.clothingItems)
        allClothingViewController.viewModel = allClothingViewModel

        allClothingViewController.modalPresentationStyle = .overFullScreen
        allClothingViewController.modalTransitionStyle = .crossDissolve

        self.parentViewController.present(
            allClothingViewController,
            animated: true,
            completion: nil
        )

        let cancel = allClothingViewModel.cancel

        return cancel
            .take(1)
            .do(onNext: { _ in
                allClothingViewController.dismiss(animated: true, completion: nil)
            })
    }
}
