//
//  PolicyViewController.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

import BasePresentation

public final class PolicyViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    public static func create(with reactor: PolicyReactor) -> PolicyViewController {
        let viewController = PolicyViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public func bind(reactor: PolicyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension PolicyViewController {
    private func bindAction(_ reactor: PolicyReactor) {
        
    }
    
    private func bindState(_ reactor: PolicyReactor) {
        
    }
}

// MARK: - Layout
extension PolicyViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
