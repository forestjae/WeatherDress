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
import SwiftUI

private enum Design {
    static let locationLabelFont: UIFont = .systemFont(ofSize: 23, weight: .semibold).metrics(for: .title3)
    static let mainFontColor: UIColor = .white
}

class WeatherViewController: UIViewController {

    var viewModel: WeatherViewModel?
    var weatherDataSource: UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>?
    var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherItem>()

    private let disposeBag = DisposeBag()

    private let hourlyWeatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private let hourlyWeatherWrappingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let hourlyWeatherCollectionView: UICollectionView = {
        let layout = createLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
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
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        stackView.layer.shadowRadius = 4
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOpacity = 0.3
        return stackView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨를 받아오는 중입니다."
        label.font = Design.locationLabelFont
        label.textColor = Design.mainFontColor
        return label
    }()

    private let isCurrentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.circle.fill")
        imageView.tintColor = .white
        return imageView
    }()

    private let currentWeatherImageView = CurrentWeatherImageView()

    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = .systemFont(ofSize: 63, weight: .medium)
        label.textColor = Design.mainFontColor
        return label
    }()

    private let currentWeatherConditionLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 22)
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
        label.text = "- / -"
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureHierarchy()
        self.configureConstraint()
        self.configureCollectionView()
        self.binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.stackView.addArrangedSubview(self.currentStackView)
        self.stackView.addArrangedSubview(self.hourlyWeatherStackView)
        self.currentStackView.addArrangedSubview(self.locationLabel)
        self.currentStackView.addSubview(self.isCurrentImage)
        self.currentStackView.addArrangedSubview(self.currentWeatherImageView)
        self.currentStackView.addArrangedSubview(self.currentTemperatureLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherConditionLabel)
        self.currentStackView.addArrangedSubview(self.currentWeatherDescriptionStackView)
        self.currentWeatherDescriptionStackView.addArrangedSubview(self.currentMinMaxTemperatureLabel)
        self.hourlyWeatherStackView.addArrangedSubview(self.hourlyWeatherWrappingView)
        self.hourlyWeatherWrappingView.addArrangedSubview(self.hourlyWeatherCollectionView)
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

        self.hourlyWeatherCollectionView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(800)
        }

        self.isCurrentImage.snp.makeConstraints {
            $0.trailing.equalTo(self.locationLabel.snp.leading).offset(-3)
            $0.centerY.equalTo(self.locationLabel).offset(-0.5)
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
        output.locationAddress
            .drive(self.locationLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.isCurrentLocation
            .map { !$0 }
            .drive(self.isCurrentImage.rx.isHidden)
            .disposed(by: self.disposeBag)

        output.currentTemperatureLabelText
            .drive(self.currentTemperatureLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.hourlyWeatherItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                let identifer = self.snapshot.itemIdentifiers(inSection: .hourly)
                self.snapshot.deleteItems(identifer)
                self.snapshot.appendItems($0.map { WeatherItem.hourly($0)}, toSection: .hourly)
                self.weatherDataSource?.apply(self.snapshot)
            })
            .disposed(by: self.disposeBag)

        output.dailyWeatherItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                let identifer = self.snapshot.itemIdentifiers(inSection: .daily)
                self.snapshot.deleteItems(identifer)
                self.snapshot.appendItems($0.map { WeatherItem.daily($0)}, toSection: .daily)
                self.weatherDataSource?.apply(self.snapshot)
            })
            .disposed(by: self.disposeBag)

        output.currentWeatherCondition
            .drive(self.currentWeatherConditionLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.currentWeatherConditionImageURL
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageURL, type in
                self?.currentWeatherImageView.setImage(by: imageURL, type: type)}
            )
            .disposed(by: self.disposeBag)

        output.minMaxTemperature
            .drive(self.currentMinMaxTemperatureLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionView() {
        self.hourlyWeatherCollectionView.register(
            HourlyWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: "hourly"
        )
        self.hourlyWeatherCollectionView.register(
            DailyWeaterCollectionViewCell.self,
            forCellWithReuseIdentifier: "daily"
        )
        self.hourlyWeatherCollectionView.register(
            HourlyCollectionReusableView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "header"
        )

        self.snapshot.appendSections([WeatherSection.hourly, WeatherSection.daily])
        self.weatherDataSource = self.dataSource()
        self.provideSupplementaryViewForWeatherCollectionView()
    }

    static func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            guard let sectionLayoutKind = WeatherSection(rawValue: sectionIndex) else {
                return nil
            }

            switch sectionLayoutKind {
            case .hourly:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                let groupHeight = NSCollectionLayoutDimension.absolute(100)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(34))
                let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: titleSize,
                    elementKind: "header",
                    alignment: .top)
                section.boundarySupplementaryItems = [titleSupplementary]
                section.orthogonalScrollingBehavior = .continuous
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background")


                section.decorationItems = [sectionBackgroundDecoration]
                return section
            case .daily:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                let groupHeight = NSCollectionLayoutDimension.absolute(45)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(34))
                let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: titleSize,
                    elementKind: "header",
                    alignment: .top)
                section.boundarySupplementaryItems = [titleSupplementary]
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background")
                section.decorationItems = [sectionBackgroundDecoration]
                return section
            }
        }, configuration: configuration)

        layout.register(
            HourlyBackgroundView.self,
            forDecorationViewOfKind: "background")

        return layout
    }
}

enum WeatherItem: Hashable {
    case hourly(HourlyWeatherItemViewModel)
    case daily(DailyWeatherItemViewModel)
}

enum WeatherSection: Int {
    case hourly
    case daily
}

extension WeatherViewController {
    func dataSource() -> UICollectionViewDiffableDataSource<WeatherSection, WeatherItem> {
        return UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>(
            collectionView: self.hourlyWeatherCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .daily(let dailyWeather):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "daily",
                    for: indexPath
                ) as? DailyWeaterCollectionViewCell
                cell?.configureContent(with: dailyWeather, index: indexPath.row)
                return cell
            case .hourly(let hourlyWeather):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "hourly",
                    for: indexPath
                ) as? HourlyWeatherCollectionViewCell
                cell?.configure(with: hourlyWeather)
                return cell
            }
        }
    }

    private func provideSupplementaryViewForWeatherCollectionView() {
        self.weatherDataSource?.supplementaryViewProvider = { (_, _, indexPath) in
            guard let header = self.hourlyWeatherCollectionView.dequeueReusableSupplementaryView(
                ofKind: "header",
                withReuseIdentifier: "header",
                for: indexPath
            ) as? HourlyCollectionReusableView else {
                return nil
            }
            let category = self.snapshot.sectionIdentifiers[indexPath.section]
            header.configure(for: category)
            return header
        }
    }
}
