//
//  IntroViewController.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class IntroViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(48.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Onboarding.appDescription
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(24.0)
        return label
    }()
    
    private let confirmButton: FilledButton = {
        let button = FilledButton(style: .large)
        button.title = Constants.Onboarding.start
        return button
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    public static func create(with reactor: IntroReactor) -> IntroViewController {
        let viewController = IntroViewController()
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
    
    public func bind(reactor: IntroReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension IntroViewController {
    private func bindAction(_ reactor: IntroReactor) {
        confirmButton.rx.tap
            .map { Reactor.Action.confirm }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: IntroReactor) {
        
    }
}

// MARK: - Layout
extension IntroViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(imageView)
                    .marginTop(25.0%)
                    .width(50.0%)
                    .aspectRatio(1.0)
                    .backgroundColor(.gray)
                rootView.addItem(titleLabel)
                    .marginTop(12.0)
                rootView.addItem(descriptionLabel)
                    .marginTop(8.0)
                rootView.addItem().grow(1.0)
                rootView.addItem(confirmButton)
                    .marginBottom(25.0%)
                    .width(60%)
                    .height(.largeButton)
                    .backgroundColor(Constants.Color.systemBlue)
                    .border(0.5, Constants.Color.systemBlack)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
}
