//
//  UIView+Shadow.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension UIView {
    var buttonShadow: Bool {
        set {
            if newValue {
                layer.addShadow()
            } else {
                layer.masksToBounds = true
                layer.shadowColor = Constants.Color.systemBlack.cgColor
                layer.shadowOpacity = 0
                layer.shadowOffset = .zero
                layer.shadowRadius = 0
                layer.shadowPath = nil
            }
        }
        get {
            return layer.shadowRadius == 0 ? true : false
        }
    }
}
