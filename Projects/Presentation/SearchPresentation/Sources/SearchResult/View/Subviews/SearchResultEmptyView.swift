//
//  SearchResultEmptyView.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import Lottie

import BasePresentation

final class SearchResultEmptyView: UIView {
    
    private let rootContainerView = UIView()
    
    private let emptyAnimationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(.emptyResult)
        return lottieView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = Constants.SearchResult.isEmpty
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    func playAnimation() {
        emptyAnimationView.loopMode = .playOnce
        emptyAnimationView.play()
    }
    
    func stopAnimation() {
        emptyAnimationView.stop()
    }
}

// MARK: - Layout
extension SearchResultEmptyView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(emptyAnimationView)
                    .width(50%)
                    .aspectRatio(1)
                rootView.addItem(label)
                    .marginTop(16.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
