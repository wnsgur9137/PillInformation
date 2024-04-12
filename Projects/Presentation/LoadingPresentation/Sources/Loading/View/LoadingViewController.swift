//
//  LoadingViewController.swift
//  LoadingPresentation
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Lottie
import FlexLayout
import PinLayout

import BasePresentation

public final class LoadingViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    public static func create(with reactor: LoadingReactor) -> LoadingViewController {
        let viewController = LoadingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: LoadingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - React
extension LoadingViewController {
    private func bindAction(_ reactor: LoadingReactor) {
        
    }
    
    private func bindState(_ reactor: LoadingReactor) {
        
    }
}

// MARK: - Layout
extension LoadingViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
