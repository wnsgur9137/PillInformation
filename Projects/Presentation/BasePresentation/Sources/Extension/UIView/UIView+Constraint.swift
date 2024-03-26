//
//  UIView+Constraint.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: -- Apply
    
    /// 좌우, 상하 - safeArea
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitSafeArea(target:UIView, constant:CGFloat = 0){
        fitWidth(target: target, constant: constant)
        NSLayoutConstraint.activate([
            self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: target.topAnchor, constant: constant),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: constant)
        ])
    }
    
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
        addLeftConstraint(target: target, constant: constant)
        addRightConstraint(target: target, constant: constant)
    }
    
    /// 상하
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitHeight(target:UIView, constant:CGFloat = 0){
        addTopConstraint(target: target, constant: constant)
        addBottomConstraint(target: target, constant: constant)
    }
    
    /// 상, 좌, 우
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitUpside(target:UIView, constant:CGFloat = 0){
        addTopConstraint(target: target, constant: constant)
        fitWidth(target: target, constant: constant)
    }
    
    /// 하, 좌, 우
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitDown(target:UIView, constant:CGFloat = 0){
        addBottomConstraint(target: target, constant: constant)
        fitWidth(target: target, constant: constant)
    }
    
    /// 좌, 상, 하
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitLeft(target:UIView, constant:CGFloat = 0){
        addLeftConstraint(target: target, constant: constant)
        fitHeight(target: target, constant: constant)
    }
    
    /// 우, 상, 하
    /// - Parameters:
    ///   - target: target
    ///   - constant: constant
    func fitRight(target:UIView, constant:CGFloat = 0){
        addRightConstraint(target: target, constant: constant)
        fitHeight(target: target, constant: constant)
    }
    
    //MARK: - Add Constraint
    func addLeftConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(leftConstraint(target: target, constant: constant))
    }
    
    func addRightConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(rightConstraint(target: target, constant: constant))
    }
    func addTopConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(topConstraint(target: target, constant: constant))
    }
    func addBottomConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(bottomConstraint(target: target, constant: constant))
    }
    func addCenterXConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(centerXConstraint(target: target, constant: constant))
    }
    func addCenterYConstraint(target:UIView, constant:CGFloat){
        target.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(centerYConstraint(target: target, constant: constant))
    }
    
    //MARK: - Make Constraint
    func centerXConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .centerX, relatedBy: .equal, toItem: target, attribute: .centerX, multiplier: 1, constant: constant)
    }
    func centerYConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .centerY, relatedBy: .equal, toItem: target, attribute: .centerY, multiplier: 1, constant: constant)
    }
    func leftConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .left, relatedBy: .equal, toItem: target, attribute: .left, multiplier: 1, constant: constant)
    }
    func rightConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .right, relatedBy: .equal, toItem: target, attribute: .right, multiplier: 1, constant: constant)
    }
    func topConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .top, relatedBy: .equal, toItem: target, attribute: .top, multiplier: 1, constant: constant)
    }
    func bottomConstraint(target:UIView, constant:CGFloat)->NSLayoutConstraint{
        .init(item: self, attribute: .bottom, relatedBy: .equal, toItem: target, attribute: .bottom, multiplier: 1, constant: constant)
    }
    
    
}
