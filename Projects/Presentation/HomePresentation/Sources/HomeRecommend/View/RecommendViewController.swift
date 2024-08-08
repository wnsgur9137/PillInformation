//
//  HomeRecommendViewController.swift
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

public final class HomeRecommendViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeRecommendReactor) -> HomeRecommendViewController {
        let viewController = HomeRecommendViewController()
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
    
    public func bind(reactor: HomeRecommendReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension HomeRecommendViewController {
    private func bindAction(_ reactor: HomeRecommendReactor) {
        
    }
    
    private func bindState(_ reactor: HomeRecommendReactor) {
        
    }
}

// MARK: - Layout
extension HomeRecommendViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex
            .define { contentView in
                contentView.addItem()
                    .backgroundColor(Constants.Color.kakaoYellow)
                    .height(1200)
                contentView.addItem()
                    .backgroundColor(Constants.Color.googleBlue)
                    .height(1200)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        scrollView.pin.top().horizontally().bottom()
        contentView.pin.top().horizontally().bottom()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
