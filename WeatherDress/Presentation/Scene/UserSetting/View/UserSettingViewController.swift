//
//  UserSettingView.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class UserSettingViewController: UIViewController {
    var viewModel: UserSettingViewModel?
    private let disposeBag = DisposeBag()
    private let pickerValue = PublishSubject<Date>()

    private let backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
        barButtonItem.tintColor = .white
        return barButtonItem
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 30

        return stackView
    }()

    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 12

        return stackView
    }()

    private let temperatureSensitiveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12

        return stackView
    }()

    private let leaveReturnTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let genderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()

    private let genderSegmentedControl: SettingSegmentedControl = {
        let segmentedControl = SettingSegmentedControl(items: ["남", "여"])
        return segmentedControl
    }()

    private let temperatureSensitiveSegmentedControl: SettingSegmentedControl = {
        let segmentedControl = SettingSegmentedControl(items: ["추위를 잘타요", "보통", "더위를 잘타요"])
        return segmentedControl
    }()

    private let temperatureSensitiveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "온도 민감도"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()

    private let leaveReturnTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 외출시간대"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()

    private let leaveHourPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    private let returnHourPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()

    private let leaveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "    외출 시간"
        label.font = .systemFont(ofSize: 15.0, weight: .semibold).metrics(for: .callout)
        label.textColor = .moderateSky
        return label
    }()

    private let returnTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "    복귀 시간"
        label.font = .systemFont(ofSize: 15.0, weight: .semibold).metrics(for: .callout)
        label.textColor = .moderateSky
        return label
    }()

    private let leaveTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let returnTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let cautionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .footnote)
        label.attributedText = "외출시간과 복귀시간은 최소 1시간의 차이가 나야해요".attach(
            with: "exclamationmark.circle",
            pointSize: label.font.pointSize,
            tintColor: label.textColor
        )
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.stackView)
        self.view.backgroundColor = .white

        self.configureController()
        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    override func viewWillLayoutSubviews() {
        self.leaveHourPicker.subviews[1].backgroundColor = .moderateSky.withAlphaComponent(0.1)
        self.returnHourPicker.subviews[1].backgroundColor = .moderateSky.withAlphaComponent(0.1)
    }

    private func configureController() {
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.title = "설정"
    }

    private func configureHierarchy() {
        self.stackView.addArrangedSubview(self.genderStackView)
        self.stackView.addArrangedSubview(self.temperatureSensitiveStackView)
        self.stackView.addArrangedSubview(self.leaveReturnTimeStackView)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.genderStackView.addArrangedSubview(self.genderTitleLabel)
        self.genderStackView.addArrangedSubview(self.genderSegmentedControl)
        self.temperatureSensitiveStackView.addArrangedSubview(self.temperatureSensitiveTitleLabel)
        self.temperatureSensitiveStackView.addArrangedSubview(self.temperatureSensitiveSegmentedControl)
        self.leaveReturnTimeStackView.addArrangedSubview(self.leaveReturnTimeTitleLabel)
        self.leaveReturnTimeStackView.addArrangedSubview(self.leaveTimeStackView)
        self.leaveReturnTimeStackView.addArrangedSubview(self.returnTimeStackView)
        self.leaveTimeStackView.addArrangedSubview(self.leaveTitleLabel)
        self.leaveTimeStackView.addArrangedSubview(self.leaveHourPicker)
        self.returnTimeStackView.addArrangedSubview(self.returnTitleLabel)
        self.returnTimeStackView.addArrangedSubview(self.returnHourPicker)
        self.leaveReturnTimeStackView.addSubview(self.cautionLabel)
    }

    private func configureConstraint() {
        self.stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
        }

        self.cautionLabel.snp.makeConstraints {
            $0.top.equalTo(self.leaveReturnTimeStackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.descriptionLabel).offset(5)
        }

        self.genderSegmentedControl.snp.makeConstraints {
            $0.width.equalTo(200)
        }

        self.descriptionLabel.snp.contentHuggingVerticalPriority = 0

        self.leaveHourPicker.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(80)
        }

        self.returnHourPicker.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(80)
        }
    }

    func binding() {
        let genderSegmentedControlIndexRelay = BehaviorRelay<Int>(value: 0)

        self.genderSegmentedControl.rx.value.asObservable()
            .subscribe(onNext: {
                genderSegmentedControlIndexRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        let temperatureSensitiveSegmentedControlIndexRelay = BehaviorRelay<Int>(value: 0)
        self.temperatureSensitiveSegmentedControl.rx.value.asObservable()
            .subscribe(onNext: {
                temperatureSensitiveSegmentedControlIndexRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        let leaveTimeRelay = BehaviorRelay(value: Date())
        let returnTimeRelay = BehaviorRelay(value: Date())
        let leaveTime = self.leaveHourPicker.rx.modelSelected(Date.self).asObservable().map { $0[0]}

        let returnTime = self.returnHourPicker.rx.modelSelected(Date.self).asObservable().map { $0[0]}

        leaveTime
            .subscribe(onNext: {
                leaveTimeRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        returnTime
            .subscribe(onNext: {
                returnTimeRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        let input = UserSettingViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in},
            genderSegmentedIndex: genderSegmentedControlIndexRelay,
            temperatureSensitiveSegmentedIndex: temperatureSensitiveSegmentedControlIndexRelay,
            leaveTime: leaveTimeRelay,
            returnTime: returnTimeRelay,
            backBarButtonDidTap: self.backBarButton.rx.tap.asObservable()
        )

        guard let output = self.viewModel?.transform(
            input: input,
            disposeBag: self.disposeBag
        ) else {
            return
        }

        output.leaveTimeDates
            .drive(self.leaveHourPicker.rx.items) { (_, date, view) in
                var label: HourPickerViewLabel
                if let reusingLabel = view as? HourPickerViewLabel {
                    label = reusingLabel
                } else {
                    let newLabel = HourPickerViewLabel()
                    label = newLabel
                }
                label.configureContent(for: date)
                return label
            }
            .disposed(by: self.disposeBag)

        output.returnTimeDates
            .drive(self.returnHourPicker.rx.items) { (_, date, view) in
                var label: HourPickerViewLabel
                if let reusingLabel = view as? HourPickerViewLabel {
                    label = reusingLabel
                } else {
                    let newLabel = HourPickerViewLabel()
                    label = newLabel
                }
                label.configureContent(for: date)
                return label
            }
            .disposed(by: self.disposeBag)

        output.setLeaveTimePickerDate
            .drive()
            .disposed(by: self.disposeBag)

        output.setReturnTimePickerDate
            .drive()
            .disposed(by: self.disposeBag)

        output.setGender
            .drive(self.genderSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)

        output.setTemperatureSensitive
            .drive(self.temperatureSensitiveSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)

        output.initialLeaveTimePickerIndex
            .withUnretained(self)
            .subscribe(onNext: { viewController, index in
                viewController.leaveHourPicker.selectRow(index, inComponent: 0, animated: true)
            })
            .disposed(by: self.disposeBag)

        output.initialReturnTimePickerIndex
            .withUnretained(self)
            .subscribe(onNext: { viewController, index in
                self.returnHourPicker.selectRow(index, inComponent: 0, animated: true)
            })
            .disposed(by: self.disposeBag)

        output.isAcceptable
            .drive(self.cautionLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}
