//
//  ImageDetailViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

import BasePresentation

public final class ImageDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.systemBlack
        return view
    }()
    
    private let topMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let bottomMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3.0
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteSemiBold(18.0)
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteMedium(12.0)
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.ImageDetail.Image.share, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.ImageDetail.Image.download, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    public static func create(with reactor: ImageDetailReactor) -> ImageDetailViewController {
        let viewController = ImageDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        scrollView.delegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: ImageDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension ImageDetailViewController {
    private func bindAction(_ reactor: ImageDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.rx.gesture(doubleTapGesture)
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.scrollView.zoomScale = 1
                }
            })
            .disposed(by: disposeBag)
        
        imageView.rx.swipeGesture(.down)
            .skip(1)
            .when(.recognized)
            .map { _ in Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ImageDetailReactor) {
        reactor.state
            .map { $0.imageURL }
            .filter { $0 != nil }
            .bind(onNext: { [weak self] url in
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.pillName }
            .filter { $0 != nil }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.className }
            .filter { $0 != nil }
            .bind(to: classLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollView Delegate
extension ImageDetailViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - Layout
extension ImageDetailViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        rootContainerView.addSubview(topMenuView)
        rootContainerView.addSubview(bottomMenuView)
        
        topMenuView.flex
            .direction(.row)
            .alignItems(.center)
            .define { topMenuView in
                topMenuView.addItem(dismissButton)
                    .width(48.0)
                    .height(48.0)
                topMenuView.addItem()
                    .grow(1)
                    .alignItems(.center)
                    .justifyContent(.center)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
                        labelStack.addItem(classLabel)
                            .marginTop(5.0)
                    }
                topMenuView.addItem()
                    .width(48.0)
                    .height(48.0)
        }
        
        bottomMenuView.flex
            .direction(.row)
            .alignItems(.center)
            .define { bottomMenuView in
                bottomMenuView.addItem(shareButton)
                    .grow(1.0)
                bottomMenuView.addItem()
                    .border(1.0, Constants.Color.systemWhite)
                    .height(40.0)
                    .width(1.0)
                bottomMenuView.addItem(downloadButton)
                    .grow(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        scrollView.pin.all()
        
        imageView.pin
            .width(scrollView.frame.width)
            .height(scrollView.frame.height)
        
        topMenuView.pin
            .left(view.safeAreaInsets.left)
            .top(view.safeAreaInsets.top + 20)
            .right(view.safeAreaInsets.right)
            .height(50.0)
        topMenuView.flex.layout()
        
        bottomMenuView.pin
            .left(view.safeAreaInsets.left)
            .bottom(view.safeAreaInsets.bottom + 20)
            .right(view.safeAreaInsets.right)
            .height(50.0)
        bottomMenuView.flex.layout()
    }
}
