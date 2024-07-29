//
//  EmptyBookmarkCell.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import Lottie

import BasePresentation

final class EmptyBookmarkView: UIView {
    
    private let rootContainerView = UIView()
    
    private let emptyAnimationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(.emptyResult)
        return lottieView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Bookmark.emptyBookmark
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(32.0)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Bookmark.emptyBookmarkDescription
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(24.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.systemBackground
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
extension EmptyBookmarkView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .backgroundColor(Constants.Color.systemBackground)
            .margin(12.0, 0, 42.0, 0)
            .alignItems(.center)
            .justifyContent(.center)
            .cornerRadius(12.0)
            .define { rootView in
                rootView.addItem(emptyAnimationView)
                    .width(40%)
                    .aspectRatio(1.0)
                    .marginTop(12.0)
                
                rootView.addItem(titleLabel)
                    .marginTop(12.0)
                    .width(100%)
                
                rootView.addItem(descriptionLabel)
                    .margin(8.0)
                    .width(100%)
                    .marginTop(12.0)
                    .marginBottom(12.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout(mode: .adjustHeight)
    }
}
