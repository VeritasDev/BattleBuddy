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
    private var currentPanAngle: Float = .pi {
        didSet {
            audioPlayer?.pan = sin(currentPanAngle.roundedToDecimalPlaces(3))
            print("Current Pan: ", audioPlayer!.pan)
        }
    }
    public var initialPanAngle: Float = 0.0
    public var currentLookDirectionAngle: Float = 0.0 {
        didSet {
            print("Look Direction: ", sin(currentLookDirectionAngle.roundedToDecimalPlaces(3)))
            let differenceFromInitialAngle = initialPanAngle - currentLookDirectionAngle
            print("Difference: ", sin(differenceFromInitialAngle.roundedToDecimalPlaces(3)))
            currentPanAngle = differenceFromInitialAngle
        }
    }

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
        initialPanAngle = randomInitialAngleRadians()
        currentPanAngle = initialPanAngle
        currentLookDirectionAngle = Float(0.0).valueInRadians().roundedToDecimalPlaces(3)
        audioPlayer?.play()
    }

    private func randomInitialAngleRadians() -> Float {
        let randomAngleDegrees = randomizedAngle()
        return randomAngleDegrees.valueInRadians()
    }

    private func randomizedAngle() -> Float {
        return Float.random(in: 0.0...360.0).roundedToDecimalPlaces(3)
    }

    public func stopTest() {
        audioPlayer?.stop()
    }

    public func reset() {
        audioPlayer?.stop()
        initialPanAngle = 0.0
        currentLookDirectionAngle = 0.0
    }

    public func updateLookDirectionAngle(radians: Float) {
        print("New Look Direction: ", sin(radians))
        currentLookDirectionAngle = radians
    }

    public func isCurrentAngleCorrect() -> Bool {
        guard let pan = audioPlayer?.pan else { return false }

        let accurateDirection = cos(initialPanAngle - currentLookDirectionAngle) > 0.0
        let threshold: Float = 0.28
        let accurateValue = abs(pan) < threshold
        return accurateDirection && accurateValue
    }

    private func sameSign(a: Float, b: Float) -> Bool {
        return ((a < 0) == (b < 0));
    }
}
