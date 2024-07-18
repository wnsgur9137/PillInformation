//
//  SplashViewController.swift
//  SplashPresentation
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
import DeviceCheck

import BasePresentation

public final class SplashViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootFlexContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.textColor = Constants.Color.systemBlue
        label.font = Constants.Font.suiteExtraBold(36.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(name: "loadingAnimation")
        lottieView.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        return lottieView
    }()
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    public static func create(with reactor: SplashReactor) -> SplashViewController {
        let viewController = SplashViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupLayout()
        setupAnimationView()
        devicecheck()
    }
    
    // TODO: - DeviceCheck을 이용해 앱 관리를 할 수 있음
    private func devicecheck() {
        let curDevice = DCDevice.current
        guard curDevice.isSupported else { return }
        Task {
            do {
                let token = try await curDevice.generateToken()
                let tokenString = token.base64EncodedString()
                print("token: \(tokenString)")
            } catch {
                print("error: \(error.localizedDescription)")
            }
            
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SplashReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setupAnimationView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}

// MARK: - React
extension SplashViewController {
    private func bindAction(_ reactor: SplashReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SplashReactor) {
        
    }
}

// MARK: - Layout
extension SplashViewController {
    private func setupLayout() {
        view.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                rootView.addItem(animationView)
                    .marginTop(40.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
