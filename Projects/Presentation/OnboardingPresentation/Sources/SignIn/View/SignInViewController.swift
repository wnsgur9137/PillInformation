//
//  SignInViewController.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class SignInViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootFlexContainerView = UIView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let appleLoginButton: SignInButton = {
        let button = SignInButton(type: .apple)
        return button
    }()
    
    private let kakaoLoginButton: SignInButton = {
        let button = SignInButton(type: .kakao)
        return button
    }()
    
    private let googleLoginButton: SignInButton = {
        let button = SignInButton(type: .google)
        return button
    }()
    
    // 사용할지 안할지 고민중
    private let lookaroundButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    public static func create(with reactor: SignInReactor) -> SignInViewController {
        let viewController = SignInViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Functions
extension SignInViewController {
    
}

// MARK: - Binding
extension SignInViewController {
    public func bind(reactor: SignInReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SignInReactor) {
        
    }
    
    private func bindState(_ reactor: SignInReactor) {
        
    }
}

// MARK: - Layout
extension SignInViewController {
    private func setupLayout() {
        view.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex.define { rootView in
            rootView.addItem(titleImageView)
            rootView.addItem(titleLabel)
            rootView.addItem(descriptionLabel)
            rootView.addItem().define { buttonStack in
                buttonStack.addItem(appleLoginButton)
                buttonStack.addItem(kakaoLoginButton)
                buttonStack.addItem(googleLoginButton)
            }
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
