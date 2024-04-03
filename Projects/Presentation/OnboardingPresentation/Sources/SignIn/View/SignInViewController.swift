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
import AuthenticationServices
import KakaoSDKUser

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
    
    private let appleSignInButton = SignInButton(type: .apple)
    private let kakaoSignInButton = SignInButton(type: .kakao)
    private let googleSignInButton = SignInButton(type: .google)
    
    // 사용할지 안할지 고민중
    private let lookaroundButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private let appleSignInSubject = PublishSubject<String>()
    private let kakaoSignInSubject = PublishSubject<String>()
    private let googleSignInSubject = PublishSubject<Void>()
    
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
    private func appleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func kakaoSignIn() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk() { oauthToken, error in
                if let error = error {
                    self.showCanNotSignInAlert(.kakao)
                    return
                }
                guard let accessToken = oauthToken?.accessToken else { return }
                self.kakaoSignInSubject.onNext(accessToken)
            }
        }
    }
    
    private func showCanNotSignInAlert(_ type: SignInType) {
        switch type {
        case .apple: break
//            let title = AlertText(text: Constants.SignIn.canNotAppleSignInTitle)
//            let message = AlertText(text: Constants.SignIn.tryAgainLater)
//            let confirmButtonInfo = AlertButtonInfo(title: Constants.SignIn.ok)
//            AlertViewer()
//                .showSingleButtonAlert(self,
//                                       title: title,
//                                       message: message,
//                                       confirmButtonInfo: confirmButtonInfo)
        case .kakao: break
            
        case .google: break
        }
    }
}

// MARK: - Binding
extension SignInViewController {
    private func bindAction(_ reactor: SignInReactor) {
        appleSignInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.appleSignIn()
            })
            .disposed(by: disposeBag)
        
        kakaoSignInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.kakaoSignIn()
            })
            .disposed(by: disposeBag)
        
        appleSignInSubject
            .map { token in Reactor.Action.didTapAppleLoginButton(token) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        kakaoSignInSubject
            .map { token in Reactor.Action.didTapKakaoLoginButton(token) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        googleSignInButton.rx.tap
            .map { Reactor.Action.didTapGoogleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SignInReactor) {
        showCanNotSignInAlert(.apple)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    
    /// 애플 로그인 성공
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityToken = appleIDCredential.identityToken,
                  let identityTokenString = String(data: identityToken, encoding: .utf8) else { return }
            appleSignInSubject.onNext(identityTokenString)
            
        default:
            showCanNotSignInAlert(.apple)
        }
    }
    
    /// 애플 로그인 실패 (취소 포함)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        showCanNotSignInAlert(.apple)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else {
            showCanNotSignInAlert(.apple)
            return UIWindow()
        }
        return window
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
                        buttonStack.addItem(appleSignInButton)
                        buttonStack.addItem(kakaoSignInButton)
                            .marginTop(10.0)
                        buttonStack.addItem(googleSignInButton)
                            .marginTop(10.0)
                    }
            }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
