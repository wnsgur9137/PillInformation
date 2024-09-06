//
//  LoadingView.swift
//  BasePresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Lottie
import FlexLayout
import PinLayout

public final class LoadingView: UIView {
    
    private let rootContainerView = UIView()
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(.loading)
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)
        view.loopMode = .loop
        return view
    }()
    
    private let testView = UIView()
    
    private let loadingBackgroundColor: UIColor
    
    public init(backgroundColor: UIColor = Constants.Color.gray800,
                backgroundAlpha: CGFloat = 0.5) {
        loadingBackgroundColor = backgroundColor.withAlphaComponent(backgroundAlpha)
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        setupSubviewLayout()
    }
    
    public func show(in view: UIView) {
        view.addSubview(self)
        self.pin.all()
        animationView.play()
    }
    
    public func hide() {
        animationView.stop()
        self.removeFromSuperview()
    }
}

// MARK: - Layout
extension LoadingView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .backgroundColor(loadingBackgroundColor)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(animationView)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
