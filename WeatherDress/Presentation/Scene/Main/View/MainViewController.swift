//
//  ViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/03/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private enum Design {
    static let locationLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
}

class MainViewController: UIViewController {
    var viewModel: MainViewModel = MainViewModel(useCase: WeatherUsecase(repository: DefaultWeatherRepository(apiService: WeatherService(apiProvider: DefaultAPIProvider()))))
    private let disposeBag = DisposeBag()

    let scrollView = UIScrollView()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "수원시 이의동"
        label.font = Design.locationLabelFont
        return label
    }()

    let currentWeatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sunny")
        return imageView
    }()

    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60)
        return label
    }()

    let currentWeatherConditionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let currentWeatherDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    let currentWeatherDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let currentMinMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()

//    let weatherCollectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    private func configureController() {
        self.view.backgroundColor = .white
    }

    private func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.stackView.addArrangedSubview(self.currentStackView)
        self.currentStackView.addArrangedSubview(self.locationLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherImageView)
        self.currentStackView.addArrangedSubview(self.currentTemperatureLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherConditionLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherDescriptionStackView)
        self.currentWeatherDescriptionStackView.addArrangedSubview(self.currentWeatherDescriptionLabel)
        self.currentWeatherDescriptionStackView.addArrangedSubview(self.currentMinMaxTemperatureLabel)
    }

    private func configureConstraint() {

        self.scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        self.currentWeatherImageView.snp.makeConstraints {
            $0.width.height.equalTo(120)
        }
    }

    private func binding() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }
        )

        let output = self.viewModel.transform(input: input, disposeBag: self.disposeBag) 

        self.bindingOutput(for: output)
    }

    private func bindingOutput(for output: MainViewModel.Output) {
        output.currentTemperatureLabelText
            .asDriver(onErrorJustReturn: "")
            .drive(self.currentTemperatureLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
