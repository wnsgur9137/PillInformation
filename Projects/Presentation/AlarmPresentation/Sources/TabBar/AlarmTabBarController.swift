//
//  AlarmTabBarController.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

import BasePresentation

public final class AlarmTabBarController: TabmanViewController {
    
    private let tabBar = TMBar.ButtonBar()
    private var viewControllers: [UIViewController]
    
    // MARK: - Life
    public static func create(viewControllers: [UIViewController]) -> AlarmTabBarController {
        let viewController = AlarmTabBarController(viewControllers: viewControllers)
        return viewController
    }
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        isScrollEnabled = false
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.dataSource = self
        tabBar.layout.transitionStyle = .snap
        tabBar.layout.alignment = .centerDistributed
        tabBar.layout.contentMode = .fit
        tabBar.backgroundView.style = .clear
        
        tabBar.buttons.customize { button in
            button.tintColor = Constants.Color.systemLightGray
            button.selectedTintColor = Constants.Color.systemDarkGray
        }
        tabBar.indicator.tintColor = Constants.Color.systemBlue
        tabBar.backgroundColor = Constants.Color.background
        
        addBar(tabBar, dataSource: self, at: .top)
    }
}

// MARK: - PageboyViewControllerDataSource
extension AlarmTabBarController: PageboyViewControllerDataSource {
    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    public func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}

// MARK: - TMBarDataSource
extension AlarmTabBarController: TMBarDataSource {
    public func barItem(for bar: any TMBar, at index: Int) -> any TMBarItemable {
        var title: String = ""
        switch index {
        case 0: title = Constants.Alarm.alarm
        case 1: title = Constants.Alarm.timer
        default: break
        }
        return TMBarItem(title: title)
    }
}
