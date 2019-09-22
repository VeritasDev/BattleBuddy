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
    var animationRotationDegrees: CGFloat = 0.0
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
        imageView.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(animationRotationDegrees));
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(play))

        view.addGestureRecognizer(gr)
        view.addSubview(animationImageView)

        animationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationImageView.heightAnchor.constraint(equalToConstant: 150.0),
            animationImageView.widthAnchor.constraint(equalToConstant: 150.0),
            animationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animationImageView.startAnimating()
    }

    @objc func play() {
        trainer.playTone()
        animationImageView.transform = .identity
    }

    @objc func handlePan() {
        // Get the translation of the pan gesture relative to our view
        let xTranslation = gr.translation(in: view).x

        // Calculate the offset with an arbitrary multiplier. If we ever want to adjust
        // sensitivity, the multiplier here is where we'd do that.
        let offset = xTranslation / view.frame.width * 0.2

        // Adjust our pan by applying the calculated offset. We subtract, rather than add, because
        // we're moving our head rather than the sound source, so it's technically inverted.
        panOffset -= offset

        print(panOffset)
//        animationRotationDegrees = panOffset * -8
//        print(animationRotationDegrees)
        animationImageView.transform = CGAffineTransform(rotationAngle: radiansToDegrees(panOffset))

        // 1 = full right
        // 0 is full center
        // -1 = full left

        // Toss our pan offset value into the sin function, which will do the hard work of simulating
        // the sound moving from in front, to the side, behind, and back around again.
        print(sin(panOffset))
        trainer.setPan(pan: Float(sin(panOffset)))
    }

    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180.0
    }

    func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
        return radians * 180.0 / .pi
    }
}
