//
//  WeatherCoordinator.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift

class WeatherCoordinator {
    let viewController: WeatherViewController

    init(viewController: WeatherViewController) {
        self.viewController = viewController
    }

    func coordinateToTimeConfiguration(
        for leaveReturnTime: (Date, Date)
    ) -> Observable<TimeConfigurationDismissAction> {
        let timeConfigurationCoordinator = TimeConfigurationCoordinator(
            parentViewController: self.viewController, for: leaveReturnTime
        )
        return timeConfigurationCoordinator.start()
    }

    func coordinateToAllClothing(
        for clotingItems: Observable<[ClothesItemViewModel]>
    ) -> Observable<Void> {
        let allClothingCoordinator = AllClothingCoordinator(
            parentViewController: self.viewController,
            for: clotingItems
        )

        return allClothingCoordinator.start()
    }
}
