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
        imageView.image = Constants.Image.appLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.textColor = Constants.Color.systemBlue
        label.font = Constants.Font.suiteExtraBold(36.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.warningMessage
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteLight(12.0)
        label.numberOfLines = 0
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
        
        rootFlexContainerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(titleImageView)
                    .width(CGSize.deviceSize.width / 4)
                    .height(CGSize.deviceSize.width / 4)
                rootView.addItem(titleLabel)
                rootView.addItem(descriptionLabel)
                    .marginLeft(20.0)
                    .marginTop(24.0)
                    .marginRight(20.0)
                rootView.addItem()
                    .marginTop(CGSize.deviceSize.height / 4.5)
                    .define { buttonStack in
                        buttonStack.addItem(appleLoginButton)
                        buttonStack.addItem(kakaoLoginButton)
                            .marginTop(10.0)
                        buttonStack.addItem(googleLoginButton)
                            .marginTop(10.0)
                    }
            }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
