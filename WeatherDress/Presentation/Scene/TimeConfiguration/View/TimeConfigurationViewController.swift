//
//  TimeConfigurationViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class TimeConfigurationViewController: ModalDimmedBackViewController {
    var viewModel: TimeConfigurationViewModel?
    private let disposeBag = DisposeBag()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "외출, 복귀 시간을 정해주세요"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    private let leaveTimeDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time

        return picker
    }()

    private let returnTimeDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        return picker
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    private let leaveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "외출 시간"
        label.textColor = .black
        return label
    }()

    private let returnTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "복귀 시간"
        label.textColor = .black
        return label
    }()

    private let leaveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let returnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        return stackView
    }()

    private let cautionLabel: UILabel = {
        let label = UILabel()
        label.text = "외출시간과 복귀시간은 최소 1시간의 차이가 나야해요!"
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .footnote)
        label.isHidden = true
        return label
    }()

    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray2, for: .disabled)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.leaveStackView)
        self.stackView.addArrangedSubview(self.returnStackView)
        self.leaveStackView.addArrangedSubview(self.leaveTitleLabel)
        self.leaveStackView.addArrangedSubview(self.leaveTimeDatePicker)
        self.returnStackView.addArrangedSubview(self.returnTitleLabel)
        self.returnStackView.addArrangedSubview(self.returnTimeDatePicker)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.stackView.addArrangedSubview(self.acceptButton)
        self.stackView.addSubview(self.cautionLabel)

        self.bottomSheetView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(270)
            $0.leading.equalTo(self.view).offset(20)
            $0.trailing.equalTo(self.view).offset(-20)
            $0.bottom.equalTo(self.view).offset(-270)
        }
        self.stackView.snp.makeConstraints {
            $0.top.equalTo(self.bottomSheetView).offset(30)
            $0.bottom.equalTo(self.bottomSheetView).offset(-30)
            $0.leading.trailing.equalTo(self.bottomSheetView).inset(10)
        }
        self.cautionLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom)
            $0.leading.equalTo(self.descriptionLabel)
        }

        self.binding()
    }

    func binding() {
        let leaveTimeRelay = BehaviorRelay(value: Date())
        let returnTimeRelay = BehaviorRelay(value: Date())
        let leaveTime = self.leaveTimeDatePicker.rx.date.share()
        let returnTime = self.returnTimeDatePicker.rx.date.share()

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

        let input = TimeConfigurationViewModel.Input(
            leaveTime: leaveTimeRelay,
            returnTime: returnTimeRelay,
            acceptButtonDidTapped: self.acceptButton.rx.tap.asObservable().debug(),
            cancelButtonDidTapped: self.cancelButton.rx.tap.asObservable().debug()
        )

        guard let output = self.viewModel?.transform(
            input: input,
            disposeBag: self.disposeBag
        ) else {
            return
        }

        output.descriptionLabelTitle
            .drive(self.descriptionLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.leaveTimePickerDate
            .drive(self.leaveTimeDatePicker.rx.date)
            .disposed(by: self.disposeBag)

        output.returnTimePickerDate
            .drive(self.returnTimeDatePicker.rx.date)
            .disposed(by: self.disposeBag)

        output.isAcceptable
            .drive(
                self.acceptButton.rx.isEnabled,
                self.cautionLabel.rx.isHidden
            )
            .disposed(by: self.disposeBag)
    }
}
