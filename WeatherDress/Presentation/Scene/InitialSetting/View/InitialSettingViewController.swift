//
//  InitialSettingViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/26.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class InitialSettingViewController: UIViewController {
    var viewModel: InitialSettingViewModel?

    private let disposeBag = DisposeBag()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 30

        return stackView
    }()

    private let settingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "앱을 사용하기 위한\n초기 설정을 진행해주세요!"
        label.font = .systemFont(ofSize: 19, weight: .semibold).metrics(for: .body)
        label.numberOfLines = 0
        return label
    }()

    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 28

        return stackView
    }()

    private let temperatureSensitiveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 30

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
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray

        return label
    }()

    private let genderSegmentedControl: SettingSegmentedControl = {
        let segmentedControl = SettingSegmentedControl(items: ["남", "여"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let temperatureSensitiveSegmentedControl: SettingSegmentedControl = {
        let segmentedControl = SettingSegmentedControl(items: ["추위를 잘타요", "보통", "더위를 잘타요"])
        segmentedControl.selectedSegmentIndex = 1
        return segmentedControl
    }()

    private let temperatureSensitiveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "온도민감도"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray

        return label
    }()

    private let leaveReturnTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "외출시간대"
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
        label.textColor = .black
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
        label.attributedText = "외출시간과 복귀시간은 최소 1시간의 차이가 나야해요!".attach(
            with: "exclamationmark.circle",
            pointSize: label.font.pointSize,
            tintColor: label.textColor
        )
        label.isHidden = true
        return label
    }()

    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .disabled)
        button.backgroundColor = .moderateSky
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold).metrics(for: .body)
        button.layer.opacity = 0.8
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.systemGray2.cgColor
        button.titleLabel?.textAlignment = .center
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureController()

        self.configureHierarchy()
        self.configureConstraint()
        self.binding()
    }

    override func viewWillLayoutSubviews() {
        self.leaveHourPicker.subviews[1].backgroundColor = .moderateSky.withAlphaComponent(0.1)
        self.returnHourPicker.subviews[1].backgroundColor = .moderateSky.withAlphaComponent(0.1)
    }

    private func configureController() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.acceptButton)
    }

    private func configureHierarchy() {
        self.stackView.addArrangedSubview(self.settingTitleLabel)
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
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

        self.acceptButton.snp.makeConstraints {
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(self.view.safeAreaLayoutGuide).dividedBy(2.5)
        }
    }

    func binding() {
        let genderSegmentedControlIndexRelay = BehaviorRelay<Int>(value: 0)

        self.genderSegmentedControl.rx.value.asObservable()
            .subscribe(onNext: {
                genderSegmentedControlIndexRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        let temperatureSensitiveSegmentedControlIndexRelay = BehaviorRelay<Int>(value: 1)
        self.temperatureSensitiveSegmentedControl.rx.value.asObservable()
            .subscribe(onNext: {
                temperatureSensitiveSegmentedControlIndexRelay.accept($0)
            })
            .disposed(by: self.disposeBag)

        let leaveTimeRelay = BehaviorRelay(value: Date())
        let returnTimeRelay = BehaviorRelay(value: Date())
        let leaveTime = self.leaveHourPicker.rx.modelSelected(Date.self).asObservable()
            .map { $0[0] }
        let returnTime = self.returnHourPicker.rx.modelSelected(Date.self).asObservable()
            .map { $0[0] }

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

        let input = InitialSettingViewModel.Input(
            genderSegmentedIndex: genderSegmentedControlIndexRelay,
            temperatureSensitiveSegmentedIndex: temperatureSensitiveSegmentedControlIndexRelay,
            leaveTime: leaveTimeRelay,
            returnTime: returnTimeRelay,
            acceptButtonDidTap: self.acceptButton.rx.tap.asObservable()
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

        output.initialLeaveTimeDate
            .asObservable()
            .subscribe(onNext: { index in
                self.leaveHourPicker.selectRow(index, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)

        output.initialReturnTimeDate
            .asObservable()
            .subscribe(onNext: { index in
                self.returnHourPicker.selectRow(index, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)

        output.isAcceptable
            .drive(
                self.cautionLabel.rx.isHidden,
                self.acceptButton.rx.isEnabled
            )
            .disposed(by: self.disposeBag)
    }
}
