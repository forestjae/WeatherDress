//
//  HourlyBackgroundView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/30.
//

import UIKit

class CollectionViewBackgroundView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.deepSky.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
