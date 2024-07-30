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
    
    private let rootFlexContainerView = UIView()
    
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
    
    private let agePolicyCheckBoxView: PolicyCheckboxView = {
        let view = PolicyCheckboxView(hasMoreButton: false)
        view.title = Constants.OnboardingPolicy.agePolicy
        return view
    }()
    
    private let appPolicyCheckBoxView: PolicyCheckboxView = {
        let view = PolicyCheckboxView(hasMoreButton: true)
        view.title = Constants.OnboardingPolicy.policy
        return view
    }()
    
    private let privacyPolicyCheckBoxView: PolicyCheckboxView = {
        let view = PolicyCheckboxView(hasMoreButton: true)
        view.title = Constants.OnboardingPolicy.privacyPolicy
        return view
    }()
    
    private let daytimeNotiPolicyCheckBoxView: PolicyCheckboxView = {
        let view = PolicyCheckboxView(hasMoreButton: false)
        view.title = Constants.OnboardingPolicy.daytimeNotificationPolicy
        return view
    }()
    
    private let nighttimeNotiPolicyCheckBoxView: PolicyCheckboxView = {
        let view = PolicyCheckboxView(hasMoreButton: false)
        view.title = Constants.OnboardingPolicy.nighttimeNotificationPolicy
        return view
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

// MARK: - Binding
extension OnboardingPolicyViewController {
    private func bindAction(_ reactor: OnboardingPolicyReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        agePolicyCheckBoxView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapAgePolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appPolicyCheckBoxView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapAppPolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        privacyPolicyCheckBoxView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapPrivacyPolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        daytimeNotiPolicyCheckBoxView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapDaytimeNotiPolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nighttimeNotiPolicyCheckBoxView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapNighttimeNotiPolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appPolicyCheckBoxView.seeMoreButton.rx.tap
            .map { Reactor.Action.didTapAppPolicyMoreButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        privacyPolicyCheckBoxView.seeMoreButton.rx.tap
            .map { Reactor.Action.didTapPrivacyPolicyMoreButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.didTapConfirmButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        allAgreeButton.rx.tap
            .map { Reactor.Action.didTapAllAgreeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: OnboardingPolicyReactor) {
        reactor.state
            .map { $0.isShowAlarmPrivacy }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isShowAlarmPrivacy in
                guard let isShowAlarmPrivacy = isShowAlarmPrivacy else { return }
                self?.daytimeNotiPolicyCheckBoxView.flex.display(isShowAlarmPrivacy ? .flex : .none)
                self?.nighttimeNotiPolicyCheckBoxView.flex.display(isShowAlarmPrivacy ? .flex : .none)
                self?.rootFlexContainerView.flex.layout()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedAgePolicy }
            .bind(onNext: { [weak self] isChecked in
                self?.agePolicyCheckBoxView.isChecked = isChecked
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedAppPolicy }
            .bind(onNext: { [weak self] isChecked in
                self?.appPolicyCheckBoxView.isChecked = isChecked
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedPrivacyPolicy }
            .bind(onNext: { [weak self] isChecked in
                self?.privacyPolicyCheckBoxView.isChecked = isChecked
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedDaytimeNotiPolicy }
            .bind(onNext: { [weak self] isChecked in
                self?.daytimeNotiPolicyCheckBoxView.isChecked = isChecked
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedNighttimeNotiPolicy }
            .bind(onNext: { [weak self] isChecked in
                self?.nighttimeNotiPolicyCheckBoxView.isChecked = isChecked
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isRequiredChecked }
            .bind(onNext: { [weak self] isChecked in
                self?.confirmButton.isEnabled = isChecked
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension OnboardingPolicyViewController {
    private func setupLayout() {
        view.addSubview(rootFlexContainerView)
        view.addSubview(backwardButton)
        
        rootFlexContainerView.flex
            .margin(20, 10, 10, 10)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .marginLeft(20.0)
                rootView.addItem(descriptionLabel)
                    .marginLeft(20.0)
                
                rootView.addItem(agePolicyCheckBoxView)
                    .marginTop(30.0)
                rootView.addItem(appPolicyCheckBoxView)
                rootView.addItem(privacyPolicyCheckBoxView)
                rootView.addItem(daytimeNotiPolicyCheckBoxView)
                rootView.addItem(nighttimeNotiPolicyCheckBoxView)
                rootView.addItem()
                    .grow(1)
                
                rootView.addItem()
                    .direction(.row)
                    .justifyContent(.start)
                    .marginTop(30.0)
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
    
    private func setupSubviewLayout() {
        backwardButton.pin
            .left(20.0)
            .top(view.safeAreaInsets.top + 10.0)
            .width(70.0)
            .height(30.0)
        rootFlexContainerView.pin
            .topLeft(to: backwardButton.anchor.bottomLeft)
            .marginVertical(10.0)
            .marginHorizontal(-20.0)
            .right(20)
            .bottom(view.safeAreaInsets.bottom)
        rootFlexContainerView.flex.layout()
    }
}
