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
    
    private let appleLoginButton = SignInButton(type: .apple)
    private let kakaoLoginButton = SignInButton(type: .kakao)
    private let googleLoginButton = SignInButton(type: .google)
    
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
        view.backgroundColor = Constants.Color.background
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SignInReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Methods
extension SignInViewController {
    
}

// MARK: - Binding
extension SignInViewController {
    private func bindAction(_ reactor: SignInReactor) {
        appleLoginButton.rx.tap
            .map { Reactor.Action.didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.didTapKakaoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        googleLoginButton.rx.tap
            .map { Reactor.Action.didTapGoogleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SignInReactor) {
        
    }
}

// MARK: - Layout
extension SignInViewController {
    private func setupLayout() {
        let deviceSize = CGSize.deviceSize
        view.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(titleImageView)
                    .width(deviceSize.width / 4)
                    .height(deviceSize.width / 4)
                rootView.addItem(titleLabel)
                rootView.addItem(descriptionLabel)
                    .marginLeft(20.0)
                    .marginTop(24.0)
                    .marginRight(20.0)
                rootView.addItem()
                    .marginTop(deviceSize.height / 4.5)
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
