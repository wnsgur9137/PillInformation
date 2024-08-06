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
        
    }
    
    private func bindState(_ reactor: HealthReactor) {
        
    }
}

// MARK: - Layout
extension HealthViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
