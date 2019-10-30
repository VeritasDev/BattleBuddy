//
//  LocalizationTrainer.swift
//  BattleBuddy
//
//  Created by Veritas on 9/12/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import AVFoundation

class LocalizationTrainer {
    private var audioPlayer: AVAudioPlayer?
    private let accuracyThreshhold: Float = 0.1
    public var currentPanAngle: Float = 0.0 { didSet {
        audioPlayer?.pan = sin(currentPanAngle)
        print(audioPlayer?.pan)
        } }
    public var initialPanAngle: Float = 0.0

    init() {
        guard let url = Bundle.main.url(forResource: "c6", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .measurement)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.numberOfLoops = 25
        } catch let error {
            print(error.localizedDescription)
        }
    }

    public func startTest() {
        audioPlayer?.stop()
        initialPanAngle = randomizedAngle()
        currentPanAngle = 0.0
        audioPlayer?.play()
    }

    private func randomizedAngle() -> Float {
        return Float.random(in: 0.0...360.0)
    }

    public func stopTest() {
        audioPlayer?.stop()
    }

    public func reset() {
        audioPlayer?.stop()
        currentPanAngle = 0.0
        initialPanAngle = 0.0
    }

    public func updatePanAngle(_ panAngle: Float) {
        currentPanAngle = panAngle
    }

    public func isCurrentAngleCorrect() -> Bool {
        let targetAngle = sin(initialPanAngle)
        let currentAngle = sin(currentPanAngle)
        let diff = abs(targetAngle - currentAngle)

        let targetAngle2 = cos(initialPanAngle)
        let currentAngle2 = cos(currentPanAngle)
        let diff2 = abs(targetAngle2 - currentAngle2)

        print("Target: ", targetAngle)
        print("Current: ", currentAngle)
        print("Diff: ", diff)

        print("Target2: ", targetAngle2)
        print("Current2: ", currentAngle2)
        print("Diff2: ", diff2)


        return diff < 0.25 && diff2 < 0.25
    }
}
