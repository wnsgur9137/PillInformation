//
//  HomeMapViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import MapKit

import BasePresentation

public final class HomeMapViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    public static func create(with reactor: HomeMapReactor) -> HomeMapViewController {
        let viewController = HomeMapViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
    
    public func bind(reactor: HomeMapReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension HomeMapViewController {
    private func bindAction(_ reactor: HomeMapReactor) {
        
    }
    
    private func bindState(_ reactor: HomeMapReactor) {
        
    }
}

// MARK: - Layout
extension HomeMapViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex
            .define { contentView in
                contentView.addItem(footerView)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        scrollView.pin.top().horizontally().bottom()
        contentView.pin.top().horizontally().bottom()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
