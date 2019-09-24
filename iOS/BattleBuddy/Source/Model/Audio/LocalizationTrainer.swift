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
    private var currentPanOffset: Float = 0.0

    init() {
        guard let url = Bundle.main.url(forResource: "c6", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .measurement)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.numberOfLoops = 10
        } catch let error {
            print(error.localizedDescription)
        }
    }

    public func startTest() {
        audioPlayer?.stop()
        currentPanOffset = Float.random(in: -1.0...1.0)
        updateAudioPlayerPan()
        audioPlayer?.play()
    }

    public func reset() {
        audioPlayer?.stop()
        currentPanOffset = 0.0
        updateAudioPlayerPan()
    }

    private func updateAudioPlayerPan() {
        audioPlayer?.pan = sin(currentPanOffset)
    }

    public func offsetPan(_ offset: Float) {
        currentPanOffset += offset
        updateAudioPlayerPan()
    }

    public func commitAnswer() -> Bool {
        guard let ap = audioPlayer else { fatalError() }
        let correct = (-0.3...0.3).contains(ap.pan)
        if correct { reset() }
        return correct
    }
}
