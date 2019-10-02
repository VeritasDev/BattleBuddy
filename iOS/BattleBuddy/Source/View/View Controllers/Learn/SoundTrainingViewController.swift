//
//  SoundTrainingViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/12/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

/**
 * [?] Button
 * What is this?
 * Have you ever had trouble locating where footsteps or gunshots were coming from? The sound training tool provides a way for you to practice your sound localization skills and get feedback in real time! Imagine you're blindfolded and can hear a sound nearby. The goal of this excercise is to pinpoint the location of the sound only by turning your head until you think the sound is directly in front of you.
 * How to use:
 * 1. Put on headphones
 * 2. Press "Start Training"
 * 3. You will hear a tone being played at a random location somewhere around you.
 * 3. Swipe left or right, just like you would move your mouse while playing the game, to simulate turning your character around.
 * 4. As you turn, you will hear the volume of the sound in each ear change as the position of the sound relative to your left and right ears will change accordingly.
 * 5. When the volume of the sound appears to be the same in both ears
 *
 * Why not footsteps or gun shot sounds?
 *
 * In front or behind?
 *
 *
 * UI:
 * Start training
 * Swipe left or right, just like you would move your mouse, to simulate turning your character in game. Once you
 *
 */
class SoundTrainingViewController: BaseViewController {
    let trainer = LocalizationTrainer()
    lazy var gr: UIPanGestureRecognizer = { UIPanGestureRecognizer(target: self, action: #selector(handlePan)) }()
    var panOffset: CGFloat = 0.0
    let sensitivity: CGFloat = 0.1
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
    lazy var commitButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("sound_training_commit".local(), for: .normal)
        button.addTarget(self, action: #selector(commit), for: .touchUpInside)
        button.applyDefaultStyle()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        title = "sound_training".local();

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(play))

        view.addGestureRecognizer(gr)
        view.addSubview(animationImageView)
        view.addSubview(commitButton)

        animationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationImageView.heightAnchor.constraint(equalToConstant: 150.0),
            animationImageView.widthAnchor.constraint(equalToConstant: 150.0),
            animationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

        commitButton.pinToBottom(xInset: 25.0, yInset: 20.0, height: 44.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animationImageView.startAnimating()
    }

    @objc func play() {
        panOffset = 0.0
        animationImageView.transform = .identity
        trainer.startTest()
    }

    @objc func handlePan() {
        // Get the translation of the pan gesture relative to our view
        let xTranslation = gr.translation(in: view).x

        // Calculate the offset with an arbitrary sensitivity multiplier.
        let offset = xTranslation / view.frame.width * sensitivity

        // Adjust our pan by applying the calculated offset. We subtract, rather than add, because
        // we're moving our head rather than the sound source, so it's technically inverted.
        panOffset -= offset

        // The inverse of the pan offset is the direction our character should now be looking.
        animationImageView.transform = CGAffineTransform(rotationAngle: -panOffset)

        // Toss our pan offset value into the sin function, which will do the hard work of simulating
        // the sound moving from in front, to the side, behind, and back around again.
        trainer.offsetPan(Float(offset))
    }

    @objc func commit() {
        let wasCorrect = trainer.commitAnswer()
        if wasCorrect {
            showOkAlert(message: "CORRECT")
        } else {
            showOkAlert(message: "WRONG")
        }
    }
}
