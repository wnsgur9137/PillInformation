//
//  AlarmSettingViewController.swift
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

public final class AlarmSettingViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: AlarmSettingReactor) -> AlarmSettingViewController {
        let viewController = AlarmSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public func bind(reactor: AlarmSettingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension AlarmSettingViewController {
    private func bindAction(_ reactor: AlarmSettingReactor) {
        
    }
    
    private func bindState(_ reactor: AlarmSettingReactor) {
        
    }
}

// MARK: - Layout
extension AlarmSettingViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
