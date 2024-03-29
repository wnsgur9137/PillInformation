//
//  OnboardingPolicyViewController.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class OnboardingPolicyViewController: UIViewController, View {
    
    // MARK: - UI instances
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.OnboardingPolicy.Image.backward, for: .normal)
        button.setTitle(Constants.OnboardingPolicy.backward, for: .normal)
        button.setTitleColor(Constants.Color.systemLabel, for: .normal)
        button.titleLabel?.font = Constants.Font.suiteMedium(20.0)
        button.tintColor = Constants.Color.systemLabel
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.OnboardingPolicy.policyTitle
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(36.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.OnboardingPolicy.policyDescription
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let confirmButton: FilledButton = {
        let button = FilledButton(style: .large, isEnabled: false)
        button.title = Constants.OnboardingPolicy.confirm
        return button
    }()
    
    private let allAgreeButton: FilledButton = {
        let button = FilledButton(style: .large)
        button.title = Constants.OnboardingPolicy.allAgreeAndConfirm
        return button
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: OnboardingPolicyReactor) -> OnboardingPolicyViewController {
        let viewController = OnboardingPolicyViewController()
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
    
    public func bind(reactor: OnboardingPolicyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Methods
extension OnboardingPolicyViewController {
    
}

// MARK: - Binding
extension OnboardingPolicyViewController {
    private func bindAction(_ reactor: OnboardingPolicyReactor) {
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
    }
    
    private func bindState(_ reactor: OnboardingPolicyReactor) {
        
    }
}

// MARK: - Layout
extension OnboardingPolicyViewController {
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(backwardButton)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView)
                .margin(10.0)
                .define { contentView in
                    contentView.addItem(titleLabel)
                    contentView.addItem(descriptionLabel)
                    contentView.addItem()
                        .direction(.row)
                        .justifyContent(.start)
                        .marginTop(20.0)
                        .marginLeft(10.0)
                        .marginRight(10.0)
                        .height(.largeButton)
                        .define { buttonStack in
                            buttonStack.addItem(confirmButton)
                                .grow(0.8)
                                .marginRight(5.0)
                            buttonStack.addItem(allAgreeButton)
                                .marginLeft(5.0)
                                .grow(1)
                        }
                }
        }
    }
    
    private func setupSubviewLayout() {
        backwardButton.pin
            .left(20.0)
            .top(view.safeAreaInsets.top + 10.0)
            .width(70.0)
            .height(30.0)
        scrollView.pin
            .topLeft(to: backwardButton.anchor.bottomLeft).marginVertical(10.0).marginHorizontal(-20.0)
            .right(20)
            .bottom(view.safeAreaInsets.bottom)
        scrollView.flex.layout()
        contentView.flex.layout()
        
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height)
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.flex.layout()
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height)
    }
}
