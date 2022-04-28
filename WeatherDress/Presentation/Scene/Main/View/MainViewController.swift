//
//  PageViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/10.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {

    var viewModel: MainViewModel?
    var orderedViewControllers: [WeatherViewController] = []

    private let disposeBag = DisposeBag()
    private let toolBar = UIToolbar()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        return pageViewController
    }()

    private lazy var listBarButtonItem: UIBarButtonItem = {
        let barButtomItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: nil
        )
        barButtomItem.tintColor = .white
        return barButtomItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
        self.configureSubviews()
        self.configureHierarchy()
        self.configureConstraint()
    }

    func setCurrentPageViewController(at index: Int) {
        self.pageViewController.dataSource = nil
        self.pageViewController.dataSource = self
        self.pageViewController.setViewControllers(
            [self.orderedViewControllers[index]],
            direction: .forward,
            animated: true
        )
        self.pageControl.currentPage = index
        self.pageViewController.didMove(toParent: self)
    }

    private func configureHierarchy() {
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.toolBar)
    }

    private func configureConstraint() {
        self.pageViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.toolBar.snp.top)
        }

        self.toolBar.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(self.view)
        }
    }

    private func configureSubviews() {
        self.configureToolbar()
        self.configurePageControl()
        self.configurePageViewController()
    }

    private func configurePageViewController() {
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    }

    private func configureToolbar() {
        self.toolBar.isHidden = false
        self.toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.pageControl),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            self.listBarButtonItem
        ]
    }

    private func configurePageControl() {
        self.pageControl.numberOfPages = 1
        if #available(iOS 14.0, *) {
            self.pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        }
    }

    private func binding() {
        guard let viewModel = self.viewModel else { return }

        let input = MainViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                .map { _ in },
            locationButtonDidTap: self.listBarButtonItem.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)

        output.locations
            .map { $0.count }
            .observe(on: MainScheduler.instance)
            .bind(to: self.pageControl.rx.numberOfPages)
            .disposed(by: self.disposeBag)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let weatherViewController = viewController as? WeatherViewController else {
            return nil
        }

        guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: weatherViewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard self.orderedViewControllers.count > previousIndex else {
            return nil
        }

        return self.orderedViewControllers[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let weatherViewController = viewController as? WeatherViewController else {
            return nil
        }
        guard let index = self.orderedViewControllers.firstIndex(of: weatherViewController) else {
            return nil
        }

        let nextIndex = index + 1
        let orderedViewControllerCount = orderedViewControllers.count

        guard orderedViewControllerCount != nextIndex else {
            return nil
        }

        guard orderedViewControllerCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}
