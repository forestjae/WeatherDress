//
//  WeatherCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

final class WeatherClothingCoordinator {
    private weak var weatherViewController: WeatherClothingViewController!

    init(weatherViewController: WeatherClothingViewController) {
        self.weatherViewController = weatherViewController
    }

    func coordinateToAllClothing(
        for clotingItems: Observable<[ClothesItemViewModel]>
    ) -> Observable<Void> {
        let allClothingCoordinator = AllClothingCoordinator(
            parentViewController: self.weatherViewController,
            for: clotingItems
        )

        return allClothingCoordinator.start()
    }
}
