//
//  CurrentWeatherImageView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/10.
//

import Foundation
import UIKit
import SnapKit
import Lottie

final class CurrentWeatherImageView: UIView {

    enum ImageType {
        case staticImage
        case animation
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private var imageView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureHierarchy()
        self.configrueConstriant()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(by imageURL: String, type: ImageType) {
        switch type {
        case .staticImage:
            self.imageView = self.setStaticImage(imageURL: imageURL)
        case .animation:
            self.imageView = self.setAnimationImage(imageURL: imageURL)
        }

        self.stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        self.stackView.addArrangedSubview(self.imageView)
    }

    private func setAnimationImage(imageURL: String) -> AnimationView {
        let animationView = AnimationView(name: imageURL)
        animationView.play()
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        return animationView
    }

    private func setStaticImage(imageURL: String) -> UIImageView {
        return UIImageView(image: UIImage(named: imageURL))
    }

    private func configureHierarchy() {
        self.addSubview(stackView)
        self.stackView.addArrangedSubview(self.imageView)
    }

    private func configrueConstriant() {
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self)
        }
    }
}
