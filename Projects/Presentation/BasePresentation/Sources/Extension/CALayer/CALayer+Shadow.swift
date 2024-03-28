//
//  CALayer+Shadow.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import QuartzCore
import UIKit

extension CALayer {
    public func addShadow(x: CGFloat = 6.0,
                     y: CGFloat = 6.0,
                     color: UIColor = Constants.Color.systemBlack,
                     alpha: Float = 0.06,
                     blur: CGFloat = 15.0,
                     spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x,
                              height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread,
                                      dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
