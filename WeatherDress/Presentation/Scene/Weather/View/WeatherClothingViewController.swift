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
    static let locationLabelFont: UIFont = .systemFont(ofSize: 23, weight: .semibold).metrics(for: .title3)
    static let mainFontColor: UIColor = .white
}

final class WeatherClothingViewController: UIViewController {
    typealias WeatherDataSource = UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>
    typealias ClothingDataSource = UICollectionViewDiffableDataSource<RecommendationSection, ClothesItemViewModel>
    typealias WeatherSnapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherItem>
    typealias ClothingSnapshot = NSDiffableDataSourceSnapshot<RecommendationSection, ClothesItemViewModel>

    var viewModel: WeatherClothingViewModel?
    var weatherDataSource: WeatherDataSource?
    var clothingDataSource: ClothingDataSource?
    var snapshot = WeatherSnapshot()
    var clotingSnapshot = ClothingSnapshot()

    private let disposeBag = DisposeBag()
    private let allClotingButtonDidTap = PublishSubject<Void>()
    private let randomButtonDidTap = PublishSubject<Void>()
    private let timeConfigureButtonDidTap = PublishSubject<Void>()
    private let leaveReturnTimeLabelText = BehaviorSubject<String>(value: "")
    private let leaveTimeSliderValue = PublishSubject<Double>()
    private let returnTimeSliderValue = PublishSubject<Double>()
    private let initialLeaveTimeSliderValue = BehaviorSubject<Double>(value: 0.0)
    private let initialReturnTimeSliderValue = BehaviorSubject<Double>(value: 24.0)

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

    private let clotingCollectionView: UICollectionView = {
        let layout = createClotingLayout()
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

    private let currentMinMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "- / -"
        label.textColor = Design.mainFontColor
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private let activityIndicator: AnimationView = {
        let animationView = AnimationView(name: "BlueActivityIndicator")
        animationView.play()
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureHierarchy()
        self.configureConstraint()
        self.configureCollectionView()
        self.configureClotingCollectionView()
        self.binding()
    }

    private func configureHierarchy() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(stackView)
        self.stackView.addArrangedSubview(self.currentStackView)
        self.stackView.addArrangedSubview(self.clotingCollectionView)
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
        self.clotingCollectionView.addSubview(self.activityIndicator)
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
            $0.height.equalTo(700)
        }

        self.clotingCollectionView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(300)
        }

        self.isCurrentImage.snp.makeConstraints {
            $0.trailing.equalTo(self.locationLabel.snp.leading).offset(-3)
            $0.centerY.equalTo(self.locationLabel).offset(-0.5)
        }

        self.activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(self.clotingCollectionView)
            $0.top.equalTo(self.clotingCollectionView).offset(50)
            $0.width.height.equalTo(110)
        }
    }

    private func binding() {
        guard let viewModel = self.viewModel else { return }
        let input = WeatherClothingViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            randomButtonTapped: self.randomButtonDidTap.asObservable(),
            allClotingButtonTapped: self.allClotingButtonDidTap.asObservable(),
            timeConfigurationButtonTapped: self.timeConfigureButtonDidTap.asObservable(),
            timeSliderLowerValueChanged: self.leaveTimeSliderValue,
            timeSliderUpperValueChnaged: self.returnTimeSliderValue
        )

        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        self.bindingOutput(for: output)
    }

    private func bindingOutput(for output: WeatherClothingViewModel.Output) {
        output.initialLeaveTime
            .subscribe(self.leaveTimeSliderValue)
            .disposed(by: self.disposeBag)

        output.initialReturnTIme
            .subscribe(self.returnTimeSliderValue)
            .disposed(by: self.disposeBag)

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

        output.recommendedClotingItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                let identifer = self.clotingSnapshot.itemIdentifiers(inSection: .cloting)
                self.clotingSnapshot.deleteItems(identifer)
                self.clotingSnapshot.appendItems($0, toSection: .cloting)
                self.clothingDataSource?.apply(self.clotingSnapshot)
            })
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

        output.leaveReturnTitleText
            .subscribe(self.leaveReturnTimeLabelText)
            .disposed(by: self.disposeBag)

        output.allClothingViewDismiss
            .subscribe()
            .disposed(by: self.disposeBag)

        output.recommendedClotingItem.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.activityIndicator.stop()
                viewController.activityIndicator.isHidden = true
            })
            .disposed(by: self.disposeBag)

        output.initialLeaveTime
            .subscribe(self.initialLeaveTimeSliderValue)
            .disposed(by: self.disposeBag)

        output.initialReturnTIme
            .subscribe(self.initialReturnTimeSliderValue)
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

    private func configureClotingCollectionView() {
        self.clotingCollectionView.register(
            RecommendationCollectionCell.self,
            forCellWithReuseIdentifier: "cloting"
        )
        self.clotingCollectionView.register(
            RecommendationCollectionHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "header"
        )
        self.clotingCollectionView.register(
            RecommendationCollectionFooterView.self,
            forSupplementaryViewOfKind: "footer",
            withReuseIdentifier: "footer"
        )

        self.clotingSnapshot.appendSections([RecommendationSection.cloting])
        self.clothingDataSource = self.dataSourceCloting()
        self.provideSupplementaryViewForClotingCollectionView()
    }

    static func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ in
                guard let sectionLayoutKind = WeatherSection(rawValue: sectionIndex) else {
                    return nil
                }

                let item = NSCollectionLayoutItem(layoutSize: sectionLayoutKind.itemSize)
                item.contentInsets = sectionLayoutKind.itemInset

                let groupSize = sectionLayoutKind.groupSize
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                let titleSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(34)
                )
                let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: titleSize,
                    elementKind: "header",
                    alignment: .top
                )
                section.boundarySupplementaryItems = [titleSupplementary]
                section.orthogonalScrollingBehavior = sectionLayoutKind.orthogonalBehavior
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background"
                )

                section.decorationItems = [sectionBackgroundDecoration]
                return section
            },
            configuration: configuration
        )

        layout.register(CollectionViewBackgroundView.self, forDecorationViewOfKind: "background")

        return layout
    }

    static func createClotingLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ in
                guard let sectionLayoutKind = RecommendationSection(rawValue: sectionIndex) else {
                    return nil
                }
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 2
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 10)

                let section = NSCollectionLayoutSection(group: group)


                let titleSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(68)
                )

                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(30.0)
                )

                let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: titleSize,
                    elementKind: "header",
                    alignment: .top
                )

                let descriptionSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: "footer",
                    alignment: .bottom
                )
                section.boundarySupplementaryItems = [titleSupplementary, descriptionSupplementary]
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background"
                )

                section.decorationItems = [sectionBackgroundDecoration]
                return section
            },
            configuration: configuration
        )

        layout.register(CollectionViewBackgroundView.self, forDecorationViewOfKind: "background")

        return layout
    }
}

enum WeatherItem: Hashable {
    case hourly(HourlyWeatherItemViewModel)
    case daily(DailyWeatherItemViewModel)
}

enum RecommendationSection: Int {
    case cloting

    var title: String {
        switch self {
        case .cloting:
            return "오늘 기온에 딱인 아이템"
        }
    }
}

enum WeatherSection: Int {
    case hourly
    case daily

    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .hourly:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .fractionalHeight(1.0)
            )
        case .daily:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .fractionalHeight(1.0)
            )
        }
    }

    var itemInset: NSDirectionalEdgeInsets {
        switch self {
        case .hourly, .daily:
            return NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        }
    }

    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .hourly:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .absolute(100)
            )
        case .daily:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(45)
            )
        }
    }

    var orthogonalBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .hourly:
            return .continuous
        case .daily:
            return .none
        }
    }
}

extension WeatherClothingViewController {
    private func dataSource() -> WeatherDataSource {
        return WeatherDataSource(
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

    private func dataSourceCloting() -> ClothingDataSource {
        return ClothingDataSource(
            collectionView: self.clotingCollectionView
        ) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cloting",
                    for: indexPath
                ) as? RecommendationCollectionCell
                cell?.configureContent(with: itemIdentifier)
                return cell
        }
    }

    private func provideSupplementaryViewForClotingCollectionView() {
        self.clothingDataSource?.supplementaryViewProvider = { (_, kind, indexPath) in
            if kind == "header" {
                let header = self.clotingCollectionView.dequeueReusableSupplementaryView(
                    ofKind: "header",
                    withReuseIdentifier: "header",
                    for: indexPath
                ) as? RecommendationCollectionHeaderView
                let category = self.clotingSnapshot.sectionIdentifiers[indexPath.section]
                header?.configure(for: category)
                header?.allClotingButton.rx.tap
                    .subscribe(self.allClotingButtonDidTap)
                    .disposed(by: self.disposeBag)

                Observable.combineLatest(self.leaveTimeSliderValue, self.returnTimeSliderValue)
                    .subscribe(onNext: {
                        let leaveHour = $0.0 < 24 ? $0.0 : $0.0 - 24
                        let returnHour = $0.1 < 24 ? $0.1 : $0.1 - 24
                        header?.leaveReturnTimeLabel.text =
                        String(Int(leaveHour)) + "시 - " + String(Int(returnHour)) + "시"
                    })
                    .disposed(by: self.disposeBag)
                
                self.initialLeaveTimeSliderValue
                    .subscribe(onNext: {
                        header?.slider.lower = $0
                    })
                    .disposed(by: self.disposeBag)
                self.initialReturnTimeSliderValue
                    .subscribe(onNext: {
                        header?.slider.upper = $0
                    })
                    .disposed(by: self.disposeBag)

                header?.slider.rx.lower
                    .subscribe(self.leaveTimeSliderValue)
                    .disposed(by: self.disposeBag)
                header?.slider.rx.upper
                    .subscribe(self.returnTimeSliderValue)
                    .disposed(by: self.disposeBag)

                return header
            } else if kind == "footer" {
                let footer = self.clotingCollectionView.dequeueReusableSupplementaryView(
                    ofKind: "footer",
                    withReuseIdentifier: "footer",
                    for: indexPath
                ) as? RecommendationCollectionFooterView

                guard let disposeBag = footer?.disposeBag else {
                    return nil
                }
                footer?.configure(for: "")
                footer?.randomButton.rx.tap
                    .subscribe(self.randomButtonDidTap)
                    .disposed(by: disposeBag)

                return footer
            } else {
                return nil
            }
        }
    }
}
