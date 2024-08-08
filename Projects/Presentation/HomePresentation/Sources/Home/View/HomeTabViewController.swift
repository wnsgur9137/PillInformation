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
    
    public static func create(tabViewControllers: [UIViewController]) -> HomeTabViewController {
        return HomeTabViewController(tabViewControllers: tabViewControllers)
    }
    
    private init(tabViewControllers: [UIViewController]) {
        self.viewControllers = tabViewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20.0
        bar.backgroundView.style = .blur(style: .regular)
        bar.buttons.customize { button in
            button.tintColor = Constants.Color.systemBlack
            button.selectedTintColor = Constants.Color.buttonHighlightBlue
        }
        bar.indicator.tintColor = Constants.Color.buttonHighlightBlue
        bar.indicator.overscrollBehavior = .compress
//        addBar(bar, dataSource: self, at: .top)
        addBar(bar, dataSource: self, at: .top)
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
        item.title = "Page \(index)"
        item.badgeValue = "New"
        return item
    }
}
