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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    private let userButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.personFill, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = Constants.Color.systemWhite
        button.backgroundColor = Constants.Color.systemBlue
        return button
    }()
    private let serachTextField = SearchTextFieldView()
    
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
        
        view.flex.backgroundColor(Constants.Color.lightGreen.withAlphaComponent(0.1))
        
        headerView.flex
            .define { headerView in
                headerView.addItem()
                    .margin(12.0, 24.0, 10.0, 24.0)
                    .direction(.row)
                    .define {
                        $0.addItem(titleLabel)
                        $0.addItem()
                            .grow(1.0)
                        $0.addItem(userButton)
                            .width(48.0)
                            .height(48.0)
                            .cornerRadius(12.0)
                    }
                headerView.addItem(serachTextField)
                    .marginBottom(12.0)
//                    .margin(12.0, 0, 12.0, 0)
            }
        
        rootContainerView.flex
            .backgroundColor(Constants.Color.background)
            .define { rootView in
                rootView.addItem(homeTabViewController.view)
            }
    }
    
    private func setupSubviewLayout() {
        headerView.pin.top(view.safeAreaInsets.top).left().right()
        headerView.flex.layout(mode: .adjustHeight)
        rootContainerView.pin
            .top(to: headerView.edge.bottom)
            .left(view.safeAreaInsets.left)
            .right(view.safeAreaInsets.right)
            .bottom()
        rootContainerView.flex.layout()
    }
}
