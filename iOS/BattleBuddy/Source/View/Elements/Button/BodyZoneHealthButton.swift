//
//  BodyZoneHealthButton.swift
//  BattleBuddy
//
//  Created by Mike on 8/26/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class BodyZoneHealthButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }

            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    var zone: BodyZone? {
        didSet {
            guard let newZone = zone else { return }
            zoneLabel.text = newZone.type.local().uppercased()

            let current = round(newZone.currentHp)
            let max = round(newZone.initialHp)
            let newPercent = CGFloat(current / max)
            self.percent = newPercent

            hpLabel.text = "\(Int(current))/\(Int(max))"

            switch newPercent {
            case 0:
                hpBarContainerView.layer.borderColor = UIColor.red.cgColor
                hpBarHpView.backgroundColor = .clear
                hpLabel.textColor = .red
            case 0..<0.1:
                hpBarContainerView.layer.borderColor = UIColor.darkGray.cgColor
                hpBarHpView.backgroundColor = .red
                hpLabel.textColor = .white
            case 0.1..<0.3:
                hpBarContainerView.layer.borderColor = UIColor.darkGray.cgColor
                hpBarHpView.backgroundColor = UIColor(red: 0.40, green: 0.27, blue: 0.0, alpha: 1.0)
                hpLabel.textColor = .white
            case 0.3..<0.5:
                hpBarContainerView.layer.borderColor = UIColor.darkGray.cgColor
                hpBarHpView.backgroundColor = UIColor(red: 0.40, green: 0.38, blue: 0.0, alpha: 1.0)
                hpLabel.textColor = .white
            case 0.5..<0.7:
                hpBarContainerView.layer.borderColor = UIColor.darkGray.cgColor
                hpBarHpView.backgroundColor = UIColor(red: 0.35, green: 0.41, blue: 0.04, alpha: 1.0)
                hpLabel.textColor = .white
            case 0.7...1.0:
                hpBarContainerView.layer.borderColor = UIColor.darkGray.cgColor
                hpBarHpView.backgroundColor = UIColor(red: 0.05, green: 0.39, blue: 0.09, alpha: 1.0)
                hpLabel.textColor = .white
            default:
                break
            }
        }
    }
    var percent: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "body_zone_background")!)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    let zoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        label.isUserInteractionEnabled = false
        return label
    }()
    let hpBarContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.Theme.background.withAlphaComponent(0.4)
        view.layer.borderWidth = 1.0
        view.isUserInteractionEnabled = false
        return view
    }()
    let hpBarHpView = UIView(frame: .zero)
    let hpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    let hpBarXInset: CGFloat = 2.0
    let damageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

        addSubview(backgroundImageView)
        backgroundImageView.addSubview(zoneLabel)

        addSubview(hpBarContainerView)
        hpBarContainerView.addSubview(hpBarHpView)
        hpBarContainerView.addSubview(hpLabel)

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        hpBarContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.17),

            hpBarContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.0),
            hpBarContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2.0),
            hpBarContainerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            hpBarContainerView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.9),
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        zoneLabel.frame = CGRect(x: 6.0, y: 2.0, width: backgroundImageView.frame.width - 12.0, height: backgroundImageView.frame.height - 4.0)
        hpLabel.frame = CGRect(x: 6.0, y: 1.0, width: hpBarContainerView.frame.width - 12.0, height: hpBarContainerView.frame.height - 2.0)

        if let percent = percent {
            let hpBarPadding: CGFloat = 2.0
            let containerWidth = hpBarContainerView.frame.width
            let totalPossibleWidth = containerWidth - (2 * hpBarPadding)
            let adjustedWidth = totalPossibleWidth * percent
            self.hpBarHpView.frame = CGRect(x: hpBarPadding, y: hpBarPadding, width: adjustedWidth, height: hpBarContainerView.frame.height - (2 * hpBarPadding))
        }
    }
}
