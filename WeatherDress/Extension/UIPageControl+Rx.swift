//
//  UIPageControl+Rx.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/12.
//

import RxSwift
import UIKit

extension Reactive where Base: UIPageControl {
    var currentLocationAvailable: Binder <Bool> {
        return Binder(self.base) { (pageControl, available) in
            if !available {
                pageControl.setIndicatorImage(nil, forPage: 0)
            } else {
                pageControl.setIndicatorImage(
                    UIImage(systemName: "location.fill"),
                    forPage: 0
                )
            }
        }
    }
}
