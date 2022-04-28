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
    static let mainFontColor: UIColor = .black
}

class WeatherViewController: UIViewController {

    var viewModel: WeatherViewModel?

    private let disposeBag = DisposeBag()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(cgColor: CGColor(red: 6/255, green: 20/255, blue: 70/255, alpha: 1))
        collectionView.layer.cornerRadius = 5
        return collectionView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(cgColor: CGColor(red: 6/255, green: 20/255, blue: 70/255, alpha: 1))
        tableView.layer.cornerRadius = 5
        return tableView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨를 받아오는 중입니다."
        label.font = Design.locationLabelFont
        label.textColor = Design.mainFontColor
        return label
    }()

    private let currentWeatherImageView = CurrentWeatherImageView()

    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 63, weight: .medium)
        label.textColor = Design.mainFontColor
        return label
    }()

    private let currentWeatherConditionLabel: UILabel = {
        let label = UILabel()
        label.text = "청명함"
        label.font = .systemFont(ofSize: 22)
        label.textColor = Design.mainFontColor
        return label
    }()

    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .medium)
        label.text = "°"
        label.textColor = Design.mainFontColor
        return label
    }()

    private let currentWeatherDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

//    let currentWeatherDescriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "어제보다 1°높아요"
//        label.font = .preferredFont(forTextStyle: .callout)
//        label.textColor = Design.mainFontColor
//        return label
//    }()

    private let currentMinMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 29° / 최저 17°"
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
        self.configureHierarchy()
        self.configureConstraint()
        self.configureCollectionView()
        self.configureTableView()
        self.binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureController() {
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 255/255, green: 255/255, blue: 246/255, alpha: 1))    }

    private func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.scrollView.addSubview(self.degreeLabel)
        self.stackView.addArrangedSubview(self.currentStackView)
        self.stackView.addArrangedSubview(self.collectionView)
        self.stackView.addArrangedSubview(self.tableView)
        self.currentStackView.addArrangedSubview(self.locationLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherImageView)
        self.currentStackView.addArrangedSubview(self.currentTemperatureLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherConditionLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherDescriptionStackView)
//        self.currentWeatherDescriptionStackView.addArrangedSubview(self.currentWeatherDescriptionLabel)
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

        self.tableView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(600)
        }
    }

    private func binding() {
        guard let viewModel = self.viewModel else { return }

        let input = WeatherViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }
        )

        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        self.bindingOutput(for: output)
    }

    private func bindingOutput(for output: WeatherViewModel.Output) {
        output.currentTemperatureLabelText
            .asDriver(onErrorJustReturn: "")
            .drive(self.currentTemperatureLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.hourlyWeathers
            .bind(to: self.collectionView.rx.items(
                cellIdentifier: "cell",
                cellType: HourlyWeatherCollectionViewCell.self
            )) { indexPath, item, cell in
                cell.configure(with: item, indexPath: indexPath)
            }
            .disposed(by: self.disposeBag)

        output.dailyWeather
            .compactMap { $0.first }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                self.currentMinMaxTemperatureLabel.text = "최고 \(item.maximumTemperature)° / 최저 \(item.minimunTemperature)°"
            })
            .disposed(by: self.disposeBag)

        output.currentWeatherCondition
            .map { $0.rawValue }
            .bind(to: self.currentWeatherConditionLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.currentWeatherCondition
            .subscribe(onNext: { item in
                DispatchQueue.main.async {
                    self.currentWeatherImageView.setImage(by: item)
                }
            })
            .disposed(by: self.disposeBag)

        output.dailyWeather
            .bind(to: self.tableView.rx.items(
                cellIdentifier: "daily",
                cellType: DailyWeaterTableViewCell.self
            )) { index, item, cell in
                cell.configure(with: item, indexPath: index)
            }
            .disposed(by: self.disposeBag)

        output.location
            .map { $0.address.fullAddress }
            .bind(to: self.locationLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionView() {
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.collectionView.register(
            HourlyWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
    }

    private func configureTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tableView.register(DailyWeaterTableViewCell.self, forCellReuseIdentifier: "daily")
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 50, height: self.collectionView.frame.height)
    }
}
