//
//  RecommendKeywordCollectionViewCell.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class RecommendKeywordCollectionViewCell: UICollectionViewCell {
    
    private let rootFlexContainerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(20.0)
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
    
    func configure(text: String) {
        label.text = text
        label.flex.markDirty()
        rootFlexContainerView.flex.layout()
    }
}

// MARK: - Layout
extension RecommendKeywordCollectionViewCell {
    private func setupLayout() {
        let height: CGFloat = 40.0
        contentView.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .height(height)
            .cornerRadius(height / 2)
            .backgroundColor(Constants.Color.background)
            .justifyContent(.center)
            .define { rootView in
            rootView.addItem(label)
                    .marginLeft(12.0)
                    .marginRight(12.0)
                    .width(100%)
                    .height(100%)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout(mode: .adjustWidth)
    }
}
