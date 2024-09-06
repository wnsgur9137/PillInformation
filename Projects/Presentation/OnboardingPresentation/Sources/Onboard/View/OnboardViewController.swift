//
//  OnboardViewController.swift
//  OnboardingPresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class OnboardViewController: UIViewController, View {
    
    // MARK: - UI instances
    
    private let rootContainerView = UIView()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Onboarding.Image.backward, for: .normal)
        button.setTitle(Constants.Onboarding.backward, for: .normal)
        button.setTitleColor(Constants.Color.label, for: .normal)
        button.titleLabel?.font = Constants.Font.suiteMedium(20.0)
        button.tintColor = Constants.Color.label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Onboarding.cautions
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(36.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Onboarding.cautionDescription
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let policyScrllView = UIScrollView()
    private let policyContentView = UIView()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.warningMessage
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(16.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let confirmButton: FilledButton = {
        let button = FilledButton(style: .large, isEnabled: true)
        button.title = Constants.Onboarding.start
        return button
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: OnboardReactor) -> OnboardViewController {
        let viewController = OnboardViewController()
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
    
    public func bind(reactor: OnboardReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension OnboardViewController {
    private func bindAction(_ reactor: OnboardReactor) {
        backwardButton.rx.tap
            .map { Reactor.Action.didTapBackwardButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backwardButton.rx.tap
            .bind(onNext: {
                UIView.animate(withDuration: 1.0) {
                    self.backwardButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.didTapConfimButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: OnboardReactor) {
        
    }
}

// MARK: - Layout
extension OnboardViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        view.addSubview(backwardButton)
        
        rootContainerView.flex
            .margin(20, 10, 10, 10)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .marginLeft(20.0)
                rootView.addItem(descriptionLabel)
                    .marginLeft(20.0)
                
                rootView.addItem()
                    .margin(20.0)
                    .border(1.0, Constants.Color.gray500)
                    .grow(1.0)
                    .define { policyView in
                        policyView.addItem(policyLabel)
                            .margin(8.0)
                    }
                
                rootView.addItem(confirmButton)
                    .margin(5.0)
            }
    }
    
    private func setupSubviewLayout() {
        backwardButton.pin
            .left(20.0)
            .top(view.safeAreaInsets.top + 10.0)
            .width(70.0)
            .height(30.0)
        rootContainerView.pin
            .topLeft(to: backwardButton.anchor.bottomLeft)
            .marginVertical(10.0)
            .marginHorizontal(-20.0)
            .right(20)
            .bottom(view.safeAreaInsets.bottom)
        rootContainerView.flex.layout()
    }
}
