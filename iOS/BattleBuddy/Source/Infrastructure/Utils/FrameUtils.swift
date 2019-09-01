//
//  FrameUtils.swift
//  BattleBuddy
//
//  Created by Mike on 7/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

internal func Frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return .init(x: x, y: y, width: width, height: height)
}

internal func CenteredInside(_ x: CGFloat, _ y: CGFloat, parentFrame: CGRect) -> CGRect {
    return .init(x: x, y: y, width: parentFrame.width - (2 * x), height: parentFrame.height - (2 * y))
}

internal func CenteredInside(width: CGFloat, height: CGFloat, parentFrame: CGRect) -> CGRect {
    return .init(x: parentFrame.width - (width / 2.0), y: parentFrame.height - (height / 2.0), width: width, height: height)
}
