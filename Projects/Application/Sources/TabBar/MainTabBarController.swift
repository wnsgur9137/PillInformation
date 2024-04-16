//
//  MainTabBarController.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation
import HomePresentation
import SearchPresentation
import AlarmPresentation
import MyPagePresentation

public final class MainTabBarController: UITabBarController {
    
    // MARK: - UI Instances
    
    private let tabBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Color.systemBackground
        view.layer.addShadow(x: 0, y: -6)
        return view
    }()
    
    private let leftButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let rightButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let centerButton: CenterButton = {
        let button = CenterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    // TabBar Animator
    private var previousSelectedIndex: Int?
    private let tabBarAnimator = TabBarAnimator()
    private weak var animatorFromDelegate: TabBarAnimatorDelegate?
    private weak var animatorToDelegate: TabBarAnimatorDelegate?
    private var tabBarButtons: [TabBarButton] = [] {
        didSet {
            tabBarView.isHidden = tabBarButtons.count <= 1
        }
    }
    
    public override var selectedIndex: Int {
        didSet {
            guard tabBarButtons.count > selectedIndex else {
                tabBarView.isHidden = true
                return
            }
            tabBarView.isHidden = false
            tabBarButtons.forEach { button in
                button.isSelected = false
            }
            tabBarButtons[selectedIndex].isSelected = true
            
            centerButton.isSelected = selectedIndex == 2
        }
    }
    
    public override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        guard let viewControllers = viewControllers else { return }
        removeTabBarItems()
        for (index, item) in viewControllers.enumerated() {
            guard let tabBarItem = item.tabBarItem else { continue }
            let button = TabBarButton()
            button.defaultImage = tabBarItem.image
            button.selectedImage = tabBarItem.image
            button.isSelected = index == 0
            let action = UIAction(handler: { [weak self] _ in
                self?.selectedIndex = index
            })
            button.addAction(action, for: .touchUpInside)
            tabBarButtons.append(button)
            
            if index == 2 {
                centerButton.imageView.image = tabBarItem.image
                centerButton.button.addAction(UIAction(handler: { [weak self] _ in
                    self?.selectedIndex = index
                }), for: .touchUpInside)
            }
        }
        
        setupButtonStackViews()
    }
    
    // MARK: - Lifecycle
    
    static func create() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        return tabBarController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
        tabBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayoutConstraints()
    }
    
    private func removeTabBarItems() {
        tabBarButtons.removeAll()
        leftButtonStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        rightButtonStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setupButtonStackViews() {
        for (index, button) in tabBarButtons.enumerated() {
            switch index {
            case 0: fallthrough
            case 1: leftButtonStackView.addArrangedSubview(button)
            case 2:  break
            case 3: fallthrough
            case 4: rightButtonStackView.addArrangedSubview(button)
            default: break
            }
        }
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

// MARK: - Layout
extension MainTabBarController {
    private func addSubviews() {
        view.addSubview(tabBarView)
        tabBarView.addSubview(leftButtonStackView)
        tabBarView.addSubview(rightButtonStackView)
        tabBarView.addSubview(centerButton)
    }
    
    private func setupLayoutConstraints() {
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tabBarView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor).isActive = true
        
        leftButtonStackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 20.0).isActive = true
        leftButtonStackView.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: 12.0).isActive = true
        leftButtonStackView.trailingAnchor.constraint(equalTo: centerButton.leadingAnchor, constant: -17.0).isActive = true
        
        rightButtonStackView.leadingAnchor.constraint(equalTo: centerButton.trailingAnchor, constant: 17.0).isActive = true
        rightButtonStackView.topAnchor.constraint(equalTo: leftButtonStackView.topAnchor).isActive = true
        rightButtonStackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -20.0).isActive = true
        
        centerButton.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: -11.0).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor).isActive = true
    }
}

