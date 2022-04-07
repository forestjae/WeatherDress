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
import Lottie

private enum Design {
    static let locationLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
}

class MainViewController: UIViewController {
    var viewModel: MainViewModel = MainViewModel(useCase: WeatherUsecase(repository: DefaultWeatherRepository(apiService: WeatherService(apiProvider: DefaultAPIProvider()))))

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(cgColor: CGColor(red: 6/255, green: 20/255, blue: 70/255, alpha: 1))
        collectionView.layer.cornerRadius = 5
        return collectionView
    }()

    private let disposeBag = DisposeBag()

    let scrollView = UIScrollView()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "수원시 이의동"
        label.font = Design.locationLabelFont
        label.textColor = .white
        return label
    }()

    let currentWeatherImageView: AnimationView = {
        let animationView = AnimationView(name: "Snow_Animated")
        animationView.play()
        animationView.loopMode = .loop
        return animationView
    }()

    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 63, weight: .medium)
        label.textColor = .white
        return label
    }()

    let currentWeatherConditionLabel: UILabel = {
        let label = UILabel()
        label.text = "청명함"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()

    let degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .medium)
        label.text = "°"
        label.textColor = .white
        return label
    }()

    let currentWeatherDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    let currentWeatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다 1°높아요"
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .white
        return label
    }()

    let currentMinMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 29° / 최저 17°"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

//    let weatherCollectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
        self.configureHierarchy()
        self.configureConstraint()
        self.configureCollectionView()
        self.binding()
    }

    private func configureController() {
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 6/255, green: 30/255, blue: 50/255, alpha: 1))    }

    private func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.scrollView.addSubview(self.degreeLabel)
        self.stackView.addArrangedSubview(self.currentStackView)
        self.stackView.addArrangedSubview(self.collectionView)
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
        self.degreeLabel.snp.makeConstraints {
            $0.leading.equalTo(self.currentTemperatureLabel.snp.trailing)
            $0.top.equalTo(self.currentTemperatureLabel.snp.top)
        }

        self.collectionView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(90)
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

        output.hourlyWeathers
            .bind(to: self.collectionView.rx.items(cellIdentifier: "cell", cellType: HourlyWeatherCollectionViewCell.self)) { indexPath, item, cell in
                cell.configure(with: item, indexPath: indexPath)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionView() {
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: self.collectionView.frame.height)
    }
}
