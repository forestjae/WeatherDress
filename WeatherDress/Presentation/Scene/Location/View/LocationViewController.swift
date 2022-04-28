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
    let disposeBag = DisposeBag()
    let locationTableView = UITableView()
    var viewModel: LocationViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.configureSubviews()
        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: LocationSearchResultViewController())
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchBar.placeholder = "위치를 입력해주세요."

        return controller
    }()

    private func configureHierarchy() {
        self.view.addSubview(self.locationTableView)
    }

    private func configureSubviews() {
        self.configureNavigationBar()
        self.configureTableView()
        self.configureSearchedTableView()
    }
    private func configureConstraint() {
        self.locationTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func configureNavigationBar() {
        self.title = "날씨"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func binding() {
        guard let searchTableViewController = self.searchController.searchResultsController as? LocationSearchResultViewController else {
            return
        }
        let searchQuery = self.searchController.searchBar.rx.text.orEmpty.asObservable()
        let newLocationCreatedOK = searchTableViewController.tableView.rx.modelSelected(LocationInfo.self).asObservable()
            .flatMap { location in
                self.alert(title: "새로운 도시를 추가하시겠습니까?", location: location)
            }

        let input = LocationViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            locationListCellSelected: self.locationTableView.rx.itemSelected.map { $0.row }.asObservable(),
            searchBarText: searchQuery,
            searchResultCellDidTap: searchTableViewController.tableView.rx.modelSelected(LocationInfo.self).asObservable(),
            listCellDidDeleted: self.locationTableView.rx.modelDeleted(LocationInfo.self).asObservable(),
            listCellDidDeletedAt: self.locationTableView.rx.itemDeleted.map { $0.row }.asObservable() ,
            createLocationAlertDidAccepted: newLocationCreatedOK
        )
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }

        output.locations
            .drive(self.locationTableView.rx.items(cellIdentifier: "cell2", cellType: LocationTableViewCell.self)) {
                index, item, cell in
                cell.configure(with: item, indexPath: index)
            }
            .disposed(by: self.disposeBag)

        output.searchedLocations
            .drive(searchTableViewController.tableView.rx.items(cellIdentifier: "cell", cellType: LocationSearchResultTableViewCell.self)) {
                index, item, cell in
                cell.configure(with: item.address.fullAddress, indexPath: index)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureSearchedTableView() {
        guard let searchTableViewController = self.searchController.searchResultsController as? LocationSearchResultViewController else {
            return
        }
        searchTableViewController.tableView.register(LocationSearchResultTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func configureTableView() {
        self.locationTableView.delegate = self
        self.locationTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cell2")
    }

    func alert(title: String, location: LocationInfo) -> Observable<ActionType> {
      return Observable.create { [weak self] observable in
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            observable.onNext(.ok(location))
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in
            observable.onNext(.cancel)
        }))
        self?.present(alert, animated: true, completion: nil)
        return Disposables.create {
          self?.dismiss(animated: true, completion: nil)
        }
      }
    }

    enum ActionType {
        case ok(LocationInfo)
        case cancel
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
