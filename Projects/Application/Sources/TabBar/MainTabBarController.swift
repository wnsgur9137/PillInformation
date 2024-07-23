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
import BookmarkPresentation
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
    
    private lazy var evenButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var leftButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var rightButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var centerButton: CenterButton = {
        let button = CenterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    // TabBar Animator
    private var previousSelectedIndex: Int = 0
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
            
            centerButton.isSelected = selectedIndex == tabBarButtons.count / 2
        }
    }
    
    public override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        guard let viewControllers = viewControllers else { return }
        let isOdd = viewControllers.count % 2 == 1
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
            
            // 탭바 버튼이 홀수인 경우에만 centerButton 설정
            guard isOdd else { continue }
            if index == viewControllers.count / 2,
               index % 2 == 1 {
                centerButton.imageView.image = tabBarItem.image
                centerButton.button.addAction(UIAction(handler: { [weak self] _ in
                    self?.selectedIndex = index
                }), for: .touchUpInside)
            }
        }
        
        isOdd ? addOddSubviews() : addEvenSubviews()
        isOdd ? setupOddLayoutConstarints() : setupEvenLayoutConstratins()
        isOdd ? setupOddButtonStackViews() : setupEvenButtonStackView()
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
        tabBar.isTranslucent = false
        tabBar.barTintColor = Constants.Color.systemBackground
        view.backgroundColor = Constants.Color.background
        addSubviews()
        setupLayoutConstraints()
    }
    
    /// Remove Buttons
    private func removeTabBarItems() {
        tabBarButtons.removeAll()
        leftButtonStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        rightButtonStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        centerButton.removeFromSuperview()
        leftButtonStackView.removeFromSuperview()
        rightButtonStackView.removeFromSuperview()
        evenButtonStackView.removeFromSuperview()
    }
    
    /// Setup Odd Button Layouts
    private func setupOddButtonStackViews() {
        for (index, button) in tabBarButtons.enumerated() {
            let centerIndex = tabBarButtons.count / 2
            
            if index < centerIndex {
                leftButtonStackView.addArrangedSubview(button)
                continue
            } else if index == centerIndex {
                continue
            } else if index > centerIndex {
                rightButtonStackView.addArrangedSubview(button)
                continue
            }
        }
    }
    
    /// Setup Even Button Layouts
    private func setupEvenButtonStackView() {
        tabBarButtons.forEach { button in
            evenButtonStackView.addArrangedSubview(button)
        }
        return
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    
    /// Set Previous selected index
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        previousSelectedIndex = tabBarController.selectedIndex
        return true
    }
    
    /// Fade animation
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        let toNavigationViewController = toVC as? UINavigationController
        var toIndex: Int?
        
        for viewController in toNavigationViewController?.viewControllers ?? [] {
            switch viewController {
            case is HomeViewController: toIndex = 0
            case is SearchViewController: toIndex = 1
            case is BookmarkViewController: toIndex = 2
            case is AlarmTabBarController: toIndex = 3
            case is MyPageViewController: toIndex = 4
            default: break
            }
        }
        
        animatorFromDelegate = fromVC as? TabBarAnimatorDelegate
        animatorToDelegate = fromVC as? TabBarAnimatorDelegate
        if previousSelectedIndex < toIndex ?? previousSelectedIndex { // left to right
            tabBarAnimator.fadeDirection = .leftToRight
            previousSelectedIndex = toIndex ?? previousSelectedIndex
            return tabBarAnimator
            
        } else if previousSelectedIndex > toIndex ??  previousSelectedIndex { // right to left
            tabBarAnimator.fadeDirection = .rightToLeft
            previousSelectedIndex = toIndex ?? previousSelectedIndex
            return tabBarAnimator
        }
        return nil
    }
}

// MARK: - Layout
extension MainTabBarController {
    private func addSubviews() {
        view.addSubview(tabBarView)
    }
    
    private func addOddSubviews() {
        tabBarView.addSubview(leftButtonStackView)
        tabBarView.addSubview(rightButtonStackView)
        tabBarView.addSubview(centerButton)
    }
    
    private func addEvenSubviews() {
        tabBarView.addSubview(evenButtonStackView)
    }
    
    private func setupLayoutConstraints() {
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tabBarView.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor).isActive = true
    }
    
    private func setupOddLayoutConstarints() {
        leftButtonStackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 20.0).isActive = true
        leftButtonStackView.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: 12.0).isActive = true
        leftButtonStackView.trailingAnchor.constraint(equalTo: centerButton.leadingAnchor, constant: -17.0).isActive = true
        
        rightButtonStackView.leadingAnchor.constraint(equalTo: centerButton.trailingAnchor, constant: 17.0).isActive = true
        rightButtonStackView.topAnchor.constraint(equalTo: leftButtonStackView.topAnchor).isActive = true
        rightButtonStackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -20.0).isActive = true
        
        centerButton.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: -11.0).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor).isActive = true
    }
    
    private func setupEvenLayoutConstratins() {
        evenButtonStackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 20.0).isActive = true
        evenButtonStackView.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: 12.0).isActive = true
        evenButtonStackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -20.0).isActive = true
    }
}

