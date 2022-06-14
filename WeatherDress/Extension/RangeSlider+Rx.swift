//.valueChanged
//  RangeSlider+Rx.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/06/10.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: RangeSlider {
    var lower: ControlProperty<Double> {
        return base.rx.controlProperty(editingEvents: [.allEditingEvents, .valueChanged]) { base in
            base.lower
        } setter: { base, catchValue in
            base.lower = catchValue
        }
    }

    var upper: ControlProperty<Double> {
        return base.rx.controlProperty(editingEvents: .valueChanged) { base in
            base.upper
        } setter: { base, catchValue in
            base.upper = catchValue
        }
    }
}
