//
//  SoundTrainingViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/12/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

private enum SoundTrainerState {
    case idle
    case training
}

class SoundTrainingViewController: BaseViewController {
    let trainer = LocalizationTrainer()
    fileprivate var state: SoundTrainerState = .idle
    lazy var gr: UIPanGestureRecognizer = { UIPanGestureRecognizer(target: self, action: #selector(handlePan)) }()
    let radianOffset: CGFloat = 2 * .pi
    var currentPanAngleRadians: CGFloat = 2 * .pi {
        didSet {
            // The inverse of the pan offset is the direction our character should now be looking.
            animationImageView.transform = CGAffineTransform(rotationAngle: currentPanAngleRadians)
            updateLookDirectionImage()
        }
    }
    let sensitivity: CGFloat = 0.05
    let soundSourceImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.yellow
        imageView.isHidden = true
        return imageView
    }()
    let currentViewDirectionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.Theme.primary
        imageView.isHidden = true
        return imageView
    }()
    lazy var animationImageView: UIImageView = {
        let imageView = UIImageView()

        var images: [UIImage] = []
        for i in 0..<20 {
            let imageName = "survivor-idle_rifle_\(i).png"
            let image = UIImage(named: imageName)!
            images.append(image)
        }
        imageView.animationImages = images
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("sound_training_start".local(), for: .normal)
        button.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        button.applyDefaultStyle()
        return button
    }()
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 28.0)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let reloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "reload")?.imageScaled(toFit: CGSize(width: 35.0, height: 35.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.Theme.primary
        return button
    }()
    lazy var helpSwitch: UISwitch = {
        let helpSwitch = UISwitch(frame: .zero)
        helpSwitch.tintColor = UIColor.Theme.primary
        helpSwitch.thumbTintColor = UIColor(white: 0.85, alpha: 1.0)
        return helpSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        title = "sound_training".local();

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "help"), style: .plain, target: self, action: #selector(showHelp))

        view.addSubview(infoLabel)
        view.addGestureRecognizer(gr)
        view.addSubview(animationImageView)
        view.addSubview(actionButton)

        infoLabel.pinToTop(xInset: 20.0, yInset: 20.0, height: 30.0)

        animationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationImageView.heightAnchor.constraint(equalToConstant: 150.0),
            animationImageView.widthAnchor.constraint(equalToConstant: 150.0),
            animationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

        actionButton.pinToBottom(xInset: 25.0, yInset: 30.0, height: 44.0)

        view.addSubview(soundSourceImageView)
        view.addSubview(currentViewDirectionImageView)

        view.addSubview(reloadButton)
        reloadButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(helpSwitch)
        helpSwitch.addTarget(self, action: #selector(toggleHelp), for: .touchUpInside)
        helpSwitch.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            reloadButton.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20.0),
            reloadButton.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 50.0),
            reloadButton.heightAnchor.constraint(equalTo: reloadButton.widthAnchor),

            helpSwitch.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20.0),
            helpSwitch.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            helpSwitch.widthAnchor.constraint(equalToConstant: 70.0),
            helpSwitch.heightAnchor.constraint(equalToConstant: 50.0),
            ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animationImageView.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateSoundSourceImage()
        updateLookDirectionImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        animationImageView.stopAnimating()
        trainer.stopTest()
    }

    @objc func showHelp() {
        navigationController?.pushViewController(PostViewController(SoundLocalizationPost()), animated: true)
    }

    @objc func handleAction() {
        switch state {
        case .idle: startTest()
        case .training: handleGuess()
        }
    }

    func updateLookDirectionImage() {
        let size: CGFloat = 50.0
        let circleRadius: CGFloat = view.frame.width * 0.4
        let angle = currentPanAngleRadians
        let xOffset = circleRadius * sin(angle)
        let yOffset = circleRadius * cos(-angle + .pi)
        let xPos = animationImageView.center.x + xOffset
        let yPos = animationImageView.center.y + yOffset
        currentViewDirectionImageView.frame = CGRect.init(x: 0.0, y: 0.0, width: size, height: size)
        currentViewDirectionImageView.center = CGPoint(x: xPos, y: yPos)
    }

    func updateSoundSourceImage() {
        let size: CGFloat = 60.0
        let circleRadius: CGFloat = view.frame.width * 0.4
        let initialAngle = CGFloat(trainer.initialPanAngle)
        let xOffset = circleRadius * sin(initialAngle)
        let yOffset = circleRadius * cos(-initialAngle + .pi)
        let xPos = animationImageView.center.x + xOffset
        let yPos = animationImageView.center.y + yOffset
        soundSourceImageView.frame = CGRect.init(x: 0.0, y: 0.0, width: size, height: size)
        soundSourceImageView.center = CGPoint(x: xPos, y: yPos)
    }

    func startTest() {
        state = .training

        currentPanAngleRadians = radianOffset

        trainer.startTest()
        updateSoundSourceImage()

        infoLabel.text = nil
        actionButton.setTitle("sound_training_commit".local(), for: .normal)
    }

    func handleGuess() {
        if trainer.isCurrentAngleCorrect() {
            infoLabel.text = "sound_training_result_correct".local()
            infoLabel.textColor = .green
            trainer.stopTest()
            actionButton.setTitle("sound_training_start".local(), for: .normal)
            state = .idle
        } else {
            infoLabel.text = "sound_training_result_wrong".local()
            infoLabel.textColor = UIColor.init(white: 0.8, alpha: 1.0)
        }
    }

    @objc func reset() {
        infoLabel.text = nil

        state = .idle

        currentPanAngleRadians = -radianOffset

        trainer.reset()
        updateSoundSourceImage()

        actionButton.setTitle("sound_training_start".local(), for: .normal)
    }

    @objc func toggleHelp() {
        let helpOn = helpSwitch.isOn
        currentViewDirectionImageView.isHidden = !helpOn
        soundSourceImageView.isHidden = !helpOn
    }

    @objc func handlePan() {
        // Get the translation of the pan gesture relative to our view
        let xTranslation = -gr.translation(in: view).x

        // Calculate the offset with an arbitrary sensitivity multiplier.
        let offset = xTranslation / view.frame.width * sensitivity

        // Adjust our pan by applying the calculated offset.
        currentPanAngleRadians = currentPanAngleRadians - offset

        trainer.updateLookDirectionAngle(radians: Float(currentPanAngleRadians))
        updateSoundSourceImage()
    }

}
