//
//  ModalDimmedBackViewController.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/25.
//

import UIKit
import SnapKit

class ModalDimmedBackViewController: UIViewController {
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()

    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightSky
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        return view
    }()

    private let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()

    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureHierarchy()
        self.configureConstraint()
        self.configureGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
        }, completion: nil)
    }

    private func configureConstraint() {
        self.dimmedBackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.view)
        }

        self.cancelButton.snp.makeConstraints {
            $0.top.equalTo(self.bottomSheetView).offset(10)
            $0.trailing.equalTo(self.bottomSheetView).offset(-20)
        }
    }

    private func configureHierarchy() {
        self.view.addSubview(self.dimmedBackView)
        self.view.addSubview(self.bottomSheetView)
        self.view.addSubview(self.dismissIndicatorView)
        self.view.addSubview(self.cancelButton)
    }

    private func configureGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        self.dimmedBackView.addGestureRecognizer(dimmedTap)
        self.dimmedBackView.isUserInteractionEnabled = true
    }

    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
