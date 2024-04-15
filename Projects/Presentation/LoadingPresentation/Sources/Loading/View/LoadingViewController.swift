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
    public static func create(with reactor: LoadingReactor) -> LoadingViewController {
        let viewController = LoadingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupLayout()
        setupAnimationView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: LoadingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setupAnimationView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}

// MARK: - React
extension LoadingViewController {
    private func bindAction(_ reactor: LoadingReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LoadingReactor) {
        
    }
}

// MARK: - Layout
extension LoadingViewController {
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
