//
//  OpenSourceLicenseViewController.swift
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

public final class OpenSourceLicenseViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: OpenSourceLicenseReactor) -> OpenSourceLicenseViewController {
        let viewController = OpenSourceLicenseViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public func bind(reactor: OpenSourceLicenseReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension OpenSourceLicenseViewController {
    private func bindAction(_ reactor: OpenSourceLicenseReactor) {
        
    }
    
    private func bindState(_ reactor: OpenSourceLicenseReactor) {
        
    }
}

// MARK: - Layout
extension OpenSourceLicenseViewController {
    private func setupLayout() {
        
    }
    
    private func setupSubviewLayout() {
        
    }
}
