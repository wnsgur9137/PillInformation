//
//  UIView+Constraint.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 좌우, 상하
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fit(target:UIView, constant:CGFloat = 0){
        fitWidth(target: target, constant: constant)
        fitHeight(target: target, constant: constant)
    }
    
    /// 좌우
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitWidth(target:UIView, constant:CGFloat = 0){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(leftConstraint(target: target, constant: constant))
        self.addConstraint(rightConstraint(target: target, constant: constant))
    }
    
    /// 상하
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitHeight(target:UIView, constant:CGFloat = 0){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(topConstraint(target: target, constant: constant))
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(bottomConstraint(target: target, constant: constant))
    }
    
    private func leftConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .left, relatedBy: .equal, toItem: target, attribute: .left, multiplier: 1, constant: constant)
    }
    private func rightConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .right, relatedBy: .equal, toItem: target, attribute: .right, multiplier: 1, constant: constant)
    }
    private func topConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .top, relatedBy: .equal, toItem: target, attribute: .top, multiplier: 1, constant: constant)
    }
    private func bottomConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .bottom, relatedBy: .equal, toItem: target, attribute: .bottom, multiplier: 1, constant: constant)
    }
}
