//
//  HomeNoticeViewController.swift
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

import BasePresentation

public final class HomeNoticeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeNoticeReactor) -> HomeNoticeViewController {
        let viewController = HomeNoticeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: HomeNoticeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension HomeNoticeViewController {
    private func bindAction(_ reactor: HomeNoticeReactor) {
        
    }
    
    private func bindState(_ reactor: HomeNoticeReactor) {
        
    }
}

// MARK: - Layout
extension HomeNoticeViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.flex
            .backgroundColor(Constants.Color.kakaoYellow)
            .define { rootView in
                
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
}
