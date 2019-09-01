//
//  MathUtils.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

func scaleBetween(unscaledNum: Float, minAllowed: Float, maxAllowed: Float, min: Float, max: Float) -> Float {
    if max - min == 0 {
        return (minAllowed + maxAllowed) / 2.0
    } else {
        return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
    }
}
