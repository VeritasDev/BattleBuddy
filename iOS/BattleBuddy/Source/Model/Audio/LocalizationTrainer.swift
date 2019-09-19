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

    init() {
        guard let url = Bundle.main.url(forResource: "c6", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .measurement)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.numberOfLoops = 50
        } catch let error {
            print(error.localizedDescription)
        }
    }

    public func playTone() {
        audioPlayer?.play()
    }

    public func setPan(pan: Float) {
        audioPlayer?.pan = pan
    }

    public func reset() {

    }
}
