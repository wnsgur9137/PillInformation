//
//  HealthViewController.swift
//  HealthPresentation
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class HealthViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Health"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    private let healthAuthView = HealthAuthView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: HealthReactor) -> HealthViewController {
        let viewController = HealthViewController()
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
    
    public func bind(reactor: HealthReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension HealthViewController {
    private func bindAction(_ reactor: HealthReactor) {
        healthAuthView.authButton.rx.tap
            .map { Reactor.Action.didTapAuthButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HealthReactor) {
        reactor.state
            .map { $0.isHealthAuthenticationRequired }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { isAuth in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension HealthViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(10.0, 24.0, 10.0, 24.0)
            rootView.addItem(healthAuthView)
                .backgroundColor(Constants.Color.systemYellow.withAlphaComponent(0.3))
                .margin(0, 24.0, 10.0, 24.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
}
