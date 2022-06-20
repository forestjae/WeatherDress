//
//  LocationSearchResultViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/11.
//

import UIKit
import SnapKit

final class LocationSearchResultViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.deepSkyDim
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureHierarchy()
        self.configureConstraint()
    }

    private func configureHierarchy() {
        self.view.addSubview(self.tableView)
    }

    private func configureConstraint() {
        self.tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
