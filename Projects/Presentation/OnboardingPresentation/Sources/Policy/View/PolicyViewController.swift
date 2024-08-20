//
//  PolicyViewController.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class PolicyViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Onboarding.Image.backward, for: .normal)
        button.setTitle(Constants.Onboarding.backward, for: .normal)
        button.setTitleColor(Constants.Color.systemBlack, for: .normal)
        button.titleLabel?.font = Constants.Font.suiteMedium(20.0)
        button.tintColor = Constants.Color.systemBlack
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemBlack
        label.font = Constants.Font.suiteMedium(20.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemBlack
        label.font = Constants.Font.suiteRegular(12.0)
        label.numberOfLines = 0
        return label
    }()
    
    public var disposeBag = DisposeBag()
    
    public static func create(with reactor: PolicyReactor) -> PolicyViewController {
        let viewController = PolicyViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemWhite
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: PolicyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension PolicyViewController {
    private func bindAction(_ reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backwardButton.rx.tap
            .map { Reactor.Action.didTapBackwardButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.policyTitle }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.policy }
            .bind(to: policyLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension PolicyViewController {
    private func setupLayout() {
        view.addSubview(backwardButton)
        view.addSubview(scrollView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView).define { contentView in
                contentView.addItem(titleLabel)
                    .margin(20, 30, 10, 30)
                contentView.addItem(policyLabel)
                    .margin(30, 30, 10, 30)
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
            .topLeft(to: backwardButton.anchor.bottomLeft)
            .marginVertical(10.0)
            .marginHorizontal(-20.0)
            .right(20.0)
            .bottom()
        scrollView.flex.layout()
        
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height)
    }
}
