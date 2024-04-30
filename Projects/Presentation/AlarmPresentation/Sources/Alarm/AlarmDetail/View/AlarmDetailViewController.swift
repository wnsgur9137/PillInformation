//
//  AlarmDetailViewController.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class AlarmDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: AlarmDetailReactor) -> AlarmDetailViewController {
        let viewController = AlarmDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alarm"
        view.backgroundColor = Constants.Color.background
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func bind(reactor: AlarmDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Methods
extension AlarmDetailViewController {
    private func bindAction(_ reactor: AlarmDetailReactor) {
        
    }
    
    private func bindState(_ reactor: AlarmDetailReactor) {
        
    }
}

// MARK: - Binding
extension AlarmDetailViewController {
    
}

// MARK: - Layout
extension AlarmDetailViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
