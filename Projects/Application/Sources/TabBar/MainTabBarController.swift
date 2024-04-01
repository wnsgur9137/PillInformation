//
//  MainTabBarController.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import HomePresentation
import SearchPresentation
import AlarmPresentation
import MyPagePresentation

public final class MainTabBarController: UITabBarController {
    // TabBar Animator
    private var previousSelectedIndex: Int?
    private let tabBarAnimator = TabBarAnimator()
    private weak var animatorFromDelegate: TabBarAnimatorDelegate?
    private weak var animatorToDelegate: TabBarAnimatorDelegate?
    
    static func create() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        return tabBarController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        previousSelectedIndex = tabBarController.selectedIndex
        return true
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let previousSelectedIndex = self.previousSelectedIndex else { return nil }
        let toNavigationViewController = toVC as? UINavigationController
        var toIndex: Int?
        
        for viewController in toNavigationViewController?.viewControllers ?? [] {
            switch viewController {
            case is HomeViewController: toIndex = 0
            case is SearchViewController: toIndex = 1
            case is AlarmViewController: toIndex = 2
            case is MyPageViewController: toIndex = 3
            default: break
            }
        }
        
        animatorFromDelegate = fromVC as? TabBarAnimatorDelegate
        animatorToDelegate = fromVC as? TabBarAnimatorDelegate
        
        
        if previousSelectedIndex < toIndex ?? previousSelectedIndex { // left to right
            tabBarAnimator.fadeDirection = .leftToRight
            return tabBarAnimator
            
        } else if previousSelectedIndex > toIndex ??  previousSelectedIndex { // right to left
            tabBarAnimator.fadeDirection = .rightToLeft
            return tabBarAnimator
        }
        return nil
    }
    
}
