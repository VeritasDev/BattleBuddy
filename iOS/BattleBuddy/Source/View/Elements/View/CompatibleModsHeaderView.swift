//
//  CompatibleModsHeaderView.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol CompatibleModsHeaderViewDelegate {
    func sortByRecoil()
    func sortByErgo()
}

class CompatibleModsHeaderView: UIView {
    let delegate: CompatibleModsHeaderViewDelegate
    lazy var stackView: UIStackView = {
        let stackView = BaseStackView(axis: .horizontal)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dividerView1)
        stackView.addArrangedSubview(ergoButton)
        stackView.addArrangedSubview(dividerView2)
        stackView.addArrangedSubview(recoilButton)
        stackView.addArrangedSubview(dividerView3)
        return stackView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "modification".local()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    lazy var recoilButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("recoil".local(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(sortByRecoil), for: .touchUpInside)
        return button
    }()
    lazy var ergoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ergo".local(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(sortByErgo), for: .touchUpInside)
        return button
    }()
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(delegate: CompatibleModsHeaderViewDelegate) {
        self.delegate = delegate

        super.init(frame: .zero)

        backgroundColor = UIColor.white.withAlphaComponent(0.9)

        addSubview(stackView)
        addSubview(bottomDividerView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1.0)
            ])

        dividerView1.constrainWidth(1.0)
        ergoButton.constrainWidth(50.0)
        dividerView2.constrainWidth(1.0)
        recoilButton.constrainWidth(50.0)
        dividerView3.constrainWidth(1.0)
    }

    @objc func sortByRecoil() {
        recoilButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        ergoButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)

        delegate.sortByRecoil()
    }

    @objc func sortByErgo() {
        recoilButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
        ergoButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)

        delegate.sortByErgo()
    }
}
