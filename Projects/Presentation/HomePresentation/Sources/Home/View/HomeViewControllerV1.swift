//
//  HomeViewControllerV1.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
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

public final class HomeViewControllerV1: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let headerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private let homeTabViewController: HomeTabViewController
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeReactor,
                              homeTabViewController: HomeTabViewController) -> HomeViewControllerV1 {
        let viewController = HomeViewControllerV1(homeTabViewController: homeTabViewController)
        viewController.reactor = reactor
        return viewController
    }
    
    private init(homeTabViewController: HomeTabViewController) {
        self.homeTabViewController = homeTabViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension HomeViewControllerV1 {
    private func bindAction(_ reactor: HomeReactor) {
        
    }
    
    private func bindState(_ reactor: HomeReactor) {
        
    }
}

// MARK: - Layout
extension HomeViewControllerV1 {
    private func setupLayout() {
        view.addSubview(headerView)
        view.addSubview(rootContainerView)
        rootContainerView.flex.define { rootView in
            rootView.addItem(homeTabViewController.view)
        }
    }
    
    private func setupSubviewLayout() {
        headerView.pin.top().left().right().height(120.0)
        rootContainerView.pin
            .top(to: headerView.edge.bottom)
            .left(view.safeAreaInsets.left)
            .right(view.safeAreaInsets.right)
            .bottom()
        rootContainerView.flex.layout()
    }
}
