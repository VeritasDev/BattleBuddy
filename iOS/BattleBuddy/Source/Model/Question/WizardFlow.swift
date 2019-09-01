//
//  WizardFlow.swift
//  BattleBuddy
//
//  Created by Mike on 8/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum StopType {
    case question
    case solution
}

struct Stop {
    let type: StopType
    let text: String
    let options: [Option]
}

struct Option {
    let text: String
    let destinationStop: Stop
}
