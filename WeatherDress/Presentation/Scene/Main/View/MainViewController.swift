//
//  PageViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/04/10.
//

import UIKit
import SnapKit
import RxSwift

final class MainViewController: UIViewController {
    var viewModel: MainViewModel?
    var orderedViewControllers: [WeatherClothingViewController] = []

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

    private let listBarButtonItem: UIBarButtonItem = {
        let barButtomItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: nil
        )
        barButtomItem.tintColor = .white
        return barButtomItem
    }()

    private let configuratingBarButtonItem: UIBarButtonItem = {
        let barButtomItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        barButtomItem.tintColor = .white
        return barButtomItem
    }()

    private let noLocationAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 표시 가능한 지역정보가 없습니다. 위치 권한을 변경하시거나 오른쪽 아래 버튼을 통해 새로운 지역을 추가해 주세요."
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
        self.configureSubviews()
        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    func setCurrentPageViewController(at index: Int) {
        self.pageViewController.setViewControllers(
            [self.orderedViewControllers[index]],
            direction: .forward,
            animated: false
        )
        self.pageControl.currentPage = index
        self.pageViewController.dataSource = nil
        self.pageViewController.dataSource = self
    }

    private func configureController() {
        self.view.backgroundColor = UIColor.lightSky
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds

        let colors: [CGColor] = [
            UIColor.init(red: 48/255, green: 97/255, blue: 213/255, alpha: 1.0).cgColor,
            UIColor.init(red: 95/255, green: 189/255, blue: 240/255, alpha: 1.0).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.addSublayer(gradientLayer)
    }

    private func configureSubviews() {
        self.configureToolbar()
        self.configurePageControl()
        self.configurePageViewController()
    }

    private func configureHierarchy() {
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.toolBar)
        self.view.addSubview(self.noLocationAvailableLabel)
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

        self.noLocationAvailableLabel.snp.makeConstraints {
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
            $0.width.equalTo(self.view.safeAreaLayoutGuide).dividedBy(1.3)
        }
    }

    private func binding() {
        guard let viewModel = self.viewModel else { return }

        let input = MainViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                .map { _ in },
            locationButtonDidTap: self.listBarButtonItem.rx.tap.asObservable(),
            configurationButtonDidTap: self.configuratingBarButtonItem.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)

        output.currentLocation
            .subscribe()
            .disposed(by: self.disposeBag)

        output.locations
            .drive(self.pageControl.rx.numberOfPages)
            .disposed(by: self.disposeBag)

       // self.setCurrentPageViewController(at: viewModel.initialIndex)
//        output.currentIndex
//            .drive(onNext: self.setCurrentPageViewController)
//            .disposed(by: self.disposeBag)

        output.currentLocationAvailable
            .drive(self.pageControl.rx.currentLocationAvailable)
            .disposed(by: self.disposeBag)

        output.anyLocationAvailable
            .drive(self.noLocationAvailableLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
    }

    private func configurePageViewController() {
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    }

    private func configureToolbar() {
        self.toolBar.barTintColor = UIColor.moderateSky
        self.toolBar.backgroundColor = .white
        self.toolBar.isHidden = false
        self.toolBar.items = [
            self.configuratingBarButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.pageControl),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            self.listBarButtonItem
        ]
    }

    private func configurePageControl() {
        self.pageControl.numberOfPages = 1
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let weatherViewController = viewController as? WeatherClothingViewController else {
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
        guard let weatherViewController = viewController as? WeatherClothingViewController else {
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
        if let viewController = pageViewController.viewControllers?.first {
            pageControl.currentPage = viewController.view.tag
        }
    }
}
