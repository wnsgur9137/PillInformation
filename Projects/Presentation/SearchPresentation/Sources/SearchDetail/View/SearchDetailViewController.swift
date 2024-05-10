//
//  SearchDetailViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import FlexLayout
import PinLayout
import Kingfisher

import BasePresentation

public final class SearchDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let navigationView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        button.setTitleColor(Constants.Color.systemBlue, for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(18.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    public static func create(with reactor: SearchDetailReactor) -> SearchDetailViewController {
        let viewController = SearchDetailViewController()
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
    
    public func bind(reactor: SearchDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func configure(_ pillInfo: PillInfoModel) {
        navigationTitleLabel.text = pillInfo.medicineName
        titleLabel.text = pillInfo.medicineName
        
        if let imageURL = URL(string: pillInfo.medicineImage) {
            imageView.kf.setImage(with: imageURL)
        }
    }
}

// MARK: - Binding
extension SearchDetailViewController {
    private func bindAction(_ reactor: SearchDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .map { Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageView.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.didTapImageView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchDetailReactor) {
        reactor.pulse(\.$pillInfo)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pillInfo in
                guard let pillInfo = pillInfo else { return }
                self?.configure(pillInfo)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension SearchDetailViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        rootContainerView.addSubview(navigationView)
        scrollView.addSubview(contentView)
        
        contentView.flex.backgroundColor(.red.withAlphaComponent(0.2)).define { contentView in
            contentView.addItem(imageView)
                .width(100%)
                .height(300)
            
            contentView.addItem().height(800).define { infoView in
                infoView.addItem(titleLabel)
                infoView.addItem().height(500) // for test
            }
        }
        
        navigationView.flex
            .direction(.row)
            .define { navigationView in
                navigationView.addItem(dismissButton)
                    .width(48.0)
                    .height(48.0)
                navigationView.addItem(navigationTitleLabel)
                    .grow(1)
                navigationView.addItem()
                    .width(48.0)
                    .height(48.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        navigationView.pin.top(view.safeAreaInsets.top).left(12.0).right(12.0).height(48.0)
        navigationView.flex.layout()
        scrollView.pin.top().horizontally().bottom()
        scrollView.flex.layout()
        contentView.pin.top(to: rootContainerView.edge.top).horizontally()
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
