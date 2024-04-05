//
//  TabBarAnimator.swift
//  Features
//
//  Created by JunHyeok Lee on 3/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

protocol TabBarAnimatorDelegate: AnyObject {
    func willStartWith(animator: TabBarAnimator)
    func didEndWith(animator: TabBarAnimator)
}

final class TabBarAnimator: NSObject {
    
    enum FadeDirection {
        case leftToRight
        case rightToLeft
    }
    
    private weak var fromDelegate: TabBarAnimatorDelegate?
    private weak var toDelegate: TabBarAnimatorDelegate?
    
    var fadeDirection: FadeDirection = .leftToRight
    
    private let duration = 0.2
    
    // MARK: - Left to Right
    private func fadeTrasition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }
        let container = transitionContext.containerView
        let distanceX = self.fadeDirection == .leftToRight ? container.frame.width / 10 : -(container.frame.width / 10)
        let dimView = UIView(frame: container.bounds)
        dimView.backgroundColor = Constants.Color.systemBackground
        
        fromDelegate?.willStartWith(animator: self)
        
        container.addSubview(dimView)
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.layoutIfNeeded()
        toView.center.x += distanceX
        toView.alpha = 0
        
        dimView.alpha = 0
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 2/3,
                               animations: {
                fromView.center.x -= distanceX * (2/3)
                toView.center.x -= distanceX * (2/3)
                fromView.alpha = 0
                dimView.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3,
                               relativeDuration: 1/3,
                               animations: {
                fromView.center.x -= distanceX * (1/3)
                toView.center.x -= distanceX * (1/3)
                toView.alpha = 1.0
                dimView.alpha = 0
            })
        }) { isSuccess in
            transitionContext.completeTransition(isSuccess)
            dimView.removeFromSuperview()
            self.toDelegate?.didEndWith(animator: self)
        }
    }
}

extension TabBarAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        fadeTrasition(using: transitionContext)
    }
}
