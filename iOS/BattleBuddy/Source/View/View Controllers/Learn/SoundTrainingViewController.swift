//
//  SoundTrainingViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/12/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SoundTrainingViewController: BaseStackViewController {
    let trainer = LocalizationTrainer()
    lazy var gr: UIPanGestureRecognizer = { UIPanGestureRecognizer(target: self, action: #selector(handlePan)) }()
    var panOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(play))

        stackView.isUserInteractionEnabled = false
        view.addGestureRecognizer(gr)
    }

    @objc func play() {
        trainer.playTone()
    }

    @objc func handlePan() {
        let xTranslation = gr.translation(in: view).x
        let offset = xTranslation / view.frame.width / 20.0
        panOffset += offset
        print(panOffset)
        trainer.setPan(pan: Float(panOffset))
    }
}
