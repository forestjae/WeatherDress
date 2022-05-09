//
//  LocationViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import UIKit
import SnapKit
import RxSwift

class LocationViewController: UIViewController {
    var viewModel: LocationViewModel?

    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<LocationSection, LocationItem>?
    private var snapshot = NSDiffableDataSourceSnapshot<LocationSection, LocationItem>()
    private let deletedAction = PublishSubject<LocationInfo>()

    private var locationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: LocationSearchResultViewController())
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchBar.barStyle = .black
        controller.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "위치를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        controller.searchBar.searchTextField.tintColor = .white
        controller.searchBar.searchTextField.backgroundColor = UIColor.darkSky
        controller.searchBar.setValue("취소", forKey: "cancelButtonText")
        controller.searchBar.tintColor = .white

        return controller
    }()

    private var deletedContextualAction: UIContextualAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.deepSky
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.configureSubviews()
        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureHierarchy() {
        self.view.addSubview(self.locationCollectionView)
    }

    private func configureSubviews() {
        self.configureNavigationBar()
        self.configureTableView()
        self.configureSearchedTableView()
    }
    private func configureConstraint() {
        self.locationCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }

    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "날씨"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.barTintColor = UIColor.deepSky
        self.navigationController?.navigationBar.barStyle = .black
    }

    private func binding() {
        guard let searchTableViewController = self.searchController
                .searchResultsController as? LocationSearchResultViewController else {
            return
        }

        let searchQuery = self.searchController.searchBar.rx.text.orEmpty.asObservable()
        let newLocationCreatedOK = searchTableViewController.tableView.rx
            .modelSelected(LocationInfo.self)
            .asObservable()
            .flatMap { location in
                self.alert(title: "새로운 도시를 추가하시겠습니까?", location: location)
            }

        let locationCreatedButtonOK = newLocationCreatedOK
            .map { result -> LocationInfo in
                switch result {
                case .accept(let locationInfo):
                    return locationInfo
                }
            }

        let input = LocationViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in },
            locationListCellSelected: self.locationCollectionView.rx
                .itemSelected.map { $0.row }
                .asObservable(),
            listCellDidDeleted: self.deletedAction.asObservable(),
            acceptedToCreateLocation: locationCreatedButtonOK,
            searchBarText: searchQuery,
            searchResultCellDidTap: searchTableViewController.tableView.rx
                .modelSelected(LocationInfo.self)
                .asObservable()
        )
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }

        Observable.combineLatest(output.locations, output.weathers)
            .subscribe(onNext: { [weak self] locations, weathers in
                guard let self = self else {
                    return
                }

                let zip = zip(locations, weathers)
                let identifer = self.snapshot.itemIdentifiers(inSection: .location)
                self.snapshot.deleteItems(identifer)
                self.snapshot.appendItems(
                    zip.map { LocationItem.location($0.0, $0.1)},
                    toSection: .location
                )
                self.dataSource?.apply(self.snapshot)
            })
            .disposed(by: self.disposeBag)

        output.searchedLocations
            .drive(searchTableViewController.tableView.rx.items(
                cellIdentifier: "cell",
                cellType: LocationSearchResultTableViewCell.self
            )) { _, item, cell in
                cell.configure(
                    with: item.address.fullAddress,
                    searchQuery: self.searchController.searchBar.text
                )
            }
            .disposed(by: self.disposeBag)

        output.locationDidDeleted
            .subscribe()
            .disposed(by: self.disposeBag)

        output.newLocationCreated
            .subscribe()
            .disposed(by: self.disposeBag)
    }

    private func configureSearchedTableView() {
        guard let searchTableViewController = self.searchController
                .searchResultsController as? LocationSearchResultViewController else {
            return
        }
        self.dataSource = self.makeDataSource()
        searchTableViewController.tableView.register(
            LocationSearchResultTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
    }

    private func configureTableView() {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.locationCollectionView = collectionView
        collectionView.backgroundColor = .clear
        self.locationCollectionView.register(
            LocationCollectionViewCell.self,
            forCellWithReuseIdentifier: "location"
        )
        self.snapshot.appendSections([LocationSection.location])
    }

    func alert(title: String, location: LocationInfo) -> Observable<ActionType> {
      return Observable.create { [weak self] observable in
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            observable.onNext(.accept(location))
            observable.onCompleted()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in
            observable.onCompleted()
        }))
        self?.present(alert, animated: true, completion: nil)
        return Disposables.create {
          self?.dismiss(animated: true, completion: nil)
        }
      }
    }

    enum ActionType {
        case accept(LocationInfo)
    }

    enum LocationSection: Int {
        case location
    }

    enum LocationItem: Hashable {
        case location(LocationInfo, CurrentWeather)
    }

}

extension LocationViewController {
    func makeDataSource() -> UICollectionViewDiffableDataSource<LocationSection, LocationItem> {
        return UICollectionViewDiffableDataSource<LocationSection, LocationItem>(
            collectionView: self.locationCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .location(let location, let weather):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "location",
                    for: indexPath
                ) as? LocationCollectionViewCell
                cell?.configure(with: location, indexPath: indexPath.row, weather: weather)
                return cell
            }
        }
    }

    private func trailingSwipeActionConfigurationForListCellItem(
        _ item: LocationItem
    ) -> UISwipeActionsConfiguration? {
        let deletedAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completion in
            switch item {
            case .location(let locationInfo, _):
                self?.deletedAction.onNext(locationInfo)
            }
            completion(true)
        }

        deletedAction.image = UIImage(systemName: "trash.fill")
        deletedAction.backgroundColor = UIColor.deepSky
        return UISwipeActionsConfiguration(actions: [deletedAction])
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)

            configuration.backgroundColor = .clear
            configuration.showsSeparators = false
            configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
                guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else {
                    return nil
                }
                return self?.trailingSwipeActionConfigurationForListCellItem(item)
            }
            let section = NSCollectionLayoutSection.list(
                using: configuration, layoutEnvironment: layoutEnvironment
            )
            section.interGroupSpacing = 10
            return section
        }

        return layout
    }
}
