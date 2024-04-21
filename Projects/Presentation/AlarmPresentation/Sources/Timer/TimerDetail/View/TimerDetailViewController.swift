//
//  TimerDetailViewController.swift
//  AlarmPresentation
//
//  Created by JUNHYEOK LEE on 4/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class TimerDetailViewController: UIViewController, View {
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: TimerDetailReactor) -> TimerDetailViewController {
        let viewController = TimerDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
    
    public func bind(reactor: TimerDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension TimerDetailViewController {
    private func bindAction(_ reactor: TimerDetailReactor) {
        
    }
    
    private func bindState(_ reactor: TimerDetailReactor) {
        
    }
}

// MARK: - Layout
extension TimerDetailViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
