//
//  AllClotingViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/21.
//

import UIKit
import RxSwift

enum ClotingSection: Int {
    case outer
    case top
    case bottoms
    case accessory

    var title: String {
        switch self {
        case .outer:
            return "아우터"
        case .top:
            return "상의"
        case .bottoms:
            return "하의"
        case .accessory:
            return "악세서리"
        }
    }
}

class AllClothingViewController: ModalDimmedBackViewController {
    var clotingDataSource: UICollectionViewDiffableDataSource<ClotingSection, ClothesItemViewModel>?
    var clotingSnapshot = NSDiffableDataSourceSnapshot<ClotingSection, ClothesItemViewModel>()
    var viewModel: AllClothingViewModel?
    private let disposeBag = DisposeBag()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.backgroundColor = .white
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천 아이템 전체보기"
        label.textColor = .black
        return label
    }()

    private let clotingCollectionView: UICollectionView = {
        let layout = createClotingLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.clotingCollectionView)
        self.bottomSheetView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(100)
            $0.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-150)
        }
        self.stackView.snp.makeConstraints {
            $0.top.equalTo(self.bottomSheetView).offset(30)
            $0.bottom.equalTo(self.bottomSheetView).offset(-30)
            $0.leading.trailing.equalTo(self.bottomSheetView)
        }
        self.clotingCollectionView.snp.makeConstraints {
            $0.width.equalTo(self.stackView)
        }
        self.configureCollectionView()
        self.binding()
    }

    func binding() {
        let input = AllClothingViewModel.Input(
            cancelButtonDidTapped: self.cancelButton.rx.tap.asObservable()
        )

        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }

        output.outerClothingItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                let identifer = self.clotingSnapshot.itemIdentifiers(inSection: .outer)
                self.clotingSnapshot.deleteItems(identifer)
                self.clotingSnapshot.appendItems($0, toSection: .outer)
                self.clotingDataSource?.apply(self.clotingSnapshot)
            })
            .disposed(by: self.disposeBag)

        output.topClothingItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                let identifer = self.clotingSnapshot.itemIdentifiers(inSection: .top)
                self.clotingSnapshot.deleteItems(identifer)
                self.clotingSnapshot.appendItems($0, toSection: .top)
                self.clotingDataSource?.apply(self.clotingSnapshot)
            })
            .disposed(by: self.disposeBag)

        output.bottomsClothingItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                let identifer = self.clotingSnapshot.itemIdentifiers(inSection: .bottoms)
                self.clotingSnapshot.deleteItems(identifer)
                self.clotingSnapshot.appendItems($0, toSection: .bottoms)
                self.clotingDataSource?.apply(self.clotingSnapshot)
            })
            .disposed(by: self.disposeBag)

        output.accessoryClothingItem
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                let identifer = self.clotingSnapshot.itemIdentifiers(inSection: .accessory)
                self.clotingSnapshot.deleteItems(identifer)
                self.clotingSnapshot.appendItems($0, toSection: .accessory)
                self.clotingDataSource?.apply(self.clotingSnapshot)
            })
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionView() {
        self.clotingCollectionView.register(
            AllClothingCollectionViewCell.self,
            forCellWithReuseIdentifier: "cloting"
        )
        self.clotingCollectionView.register(
            AllClotingCollectionHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "header"
        )

        self.clotingSnapshot.appendSections(
            [
            ClotingSection.outer,
            ClotingSection.top,
            ClotingSection.bottoms,
            ClotingSection.accessory
            ]
        )

        self.clotingDataSource = self.dataSourceCloting()
        self.provideSupplementaryViewForClotingCollectionView()
    }

    static func createClotingLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ in
                guard let sectionLayoutKind = ClotingSection(rawValue: sectionIndex) else {
                    return nil
                }
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 10, bottom: 1, trailing: 10)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .absolute(80)
                )

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
                section.orthogonalScrollingBehavior = .continuous
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "background"
                )

                section.decorationItems = [sectionBackgroundDecoration]
                return section
            },
            configuration: configuration
        )

        layout.register(HourlyBackgroundView.self, forDecorationViewOfKind: "background")

        return layout
    }

    func dataSourceCloting() -> UICollectionViewDiffableDataSource<ClotingSection, ClothesItemViewModel> {
        return UICollectionViewDiffableDataSource<ClotingSection, ClothesItemViewModel>(
            collectionView: self.clotingCollectionView
        ) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cloting",
                    for: indexPath
                ) as? AllClothingCollectionViewCell
                cell?.configureContent(with: itemIdentifier)
                return cell
        }
    }

    private func provideSupplementaryViewForClotingCollectionView() {
        self.clotingDataSource?.supplementaryViewProvider = { (_, _, indexPath) in
            var supplementaryView: UICollectionReusableView
            let header = self.clotingCollectionView.dequeueReusableSupplementaryView(
                ofKind: "header",
                withReuseIdentifier: "header",
                for: indexPath
            ) as? AllClotingCollectionHeaderView
            let category = self.clotingSnapshot.sectionIdentifiers[indexPath.section]
            header?.configure(for: category)
            return header
        }
    }
}
