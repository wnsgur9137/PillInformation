//
//  HomeTabViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Tabman
import Pageboy

import BasePresentation

public final class HomeTabViewController: TabmanViewController {
    
    private let viewControllers: [UIViewController]
    private let tabTitles: [String]
    private let isNewTabs: [Bool]
    
    let isScrolled: PublishRelay<Float> = .init()
    
    public static func create(tabViewControllers: [UIViewController],
                              tabTitles: [String],
                              isNewTabs: [Bool]) -> HomeTabViewController {
        return HomeTabViewController(tabViewControllers: tabViewControllers, tabTitles: tabTitles, isNewTabs: isNewTabs)
    }
    
    private init(tabViewControllers: [UIViewController], tabTitles: [String], isNewTabs: [Bool]) {
        self.viewControllers = tabViewControllers
        self.tabTitles = tabTitles
        self.isNewTabs = isNewTabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupTabBar()
        setupScrollRelay()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.scrollMode = .none
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20.0
        bar.backgroundView.style = .blur(style: .regular)
        bar.buttons.customize { button in
            button.tintColor = Constants.Color.label
            button.selectedTintColor = Constants.Color.buttonHighlightBlue
        }
        bar.indicator.tintColor = Constants.Color.buttonHighlightBlue
        bar.indicator.overscrollBehavior = .compress
//        addBar(bar, dataSource: self, at: .top)
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func setupScrollRelay() {
        
    }
}

// MARK: - PageboyViewControllerDataSource
extension HomeTabViewController: PageboyViewControllerDataSource {
    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    public func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

// MARK: - TMBarDataSource
extension HomeTabViewController: TMBarDataSource {
    public func barItem(for bar: any TMBar, at index: Int) -> any TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = tabTitles[index]
        item.badgeValue = isNewTabs[index] ? "New" : nil
        return item
    }
}
