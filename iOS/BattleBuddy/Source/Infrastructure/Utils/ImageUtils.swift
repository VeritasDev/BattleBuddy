//
//  ImageUtils
//  BattleBuddy
//
//  Created by Mike on 8/6/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

extension UIImage {

    public func imageScaled(toFit size: CGSize) -> UIImage {
        if size == .zero { fatalError("Can't scale a zero-size image!" )}

        let myWidth = self.size.width
        let myHeight = self.size.height
        let newWidth = size.width
        let newHeight = size.height
        let imageAspectRatio = myWidth / myHeight
        let canvasAspectRatio = newWidth / newHeight
        let sizeByWidth = imageAspectRatio > canvasAspectRatio
        let resizeFactor: CGFloat = sizeByWidth ? (newWidth / myWidth) : (newHeight / myHeight)
        let scaledSize = CGSize(width: myWidth * resizeFactor, height: myHeight * resizeFactor)
        let origin = CGPoint(x: (newWidth - scaledSize.width) / 2.0, y: (newHeight - scaledSize.height) / 2.0)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
