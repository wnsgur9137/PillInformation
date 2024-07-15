//
//  ColorCollectionViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class ColorCollectionViewCell: UICollectionViewCell {
    
    private let rootContainerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteSemiBold(24.0)
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
    
    func configure(_ color: SearchColorItems) {
        var backgroundColor: UIColor? = Constants.Color.systemBackground
        var labelTextColor: UIColor? = Constants.Color.systemLabel
        switch color {
        case .brown: 
            backgroundColor = Constants.Color.systemBrown
            labelTextColor = Constants.Color.systemWhite
        case .orange:
            backgroundColor = Constants.Color.systemOrange
            labelTextColor = Constants.Color.systemWhite
        case .white:
            backgroundColor = Constants.Color.systemWhite
            labelTextColor = Constants.Color.systemBlack
        case .yellow:
            backgroundColor = Constants.Color.systemYellow
            labelTextColor = Constants.Color.systemBlack
        case .blue:
            backgroundColor = Constants.Color.systemBlue
            labelTextColor = Constants.Color.systemWhite
        case .pink:
            backgroundColor = Constants.Color.systemPink
            labelTextColor = Constants.Color.systemBlack
        case .black:
            backgroundColor = Constants.Color.systemBlack
            labelTextColor = Constants.Color.systemWhite
        case .lightGreen:
            backgroundColor = Constants.Color.lightGreen
            labelTextColor = Constants.Color.systemBlack
        case .green:
            backgroundColor = Constants.Color.systemGreen
            labelTextColor = Constants.Color.systemWhite
        case .red:
            backgroundColor = Constants.Color.systemRed
            labelTextColor = Constants.Color.systemWhite
        case .wine:
            backgroundColor = Constants.Color.wine
            labelTextColor = Constants.Color.systemWhite
        case .purple:
            backgroundColor = Constants.Color.systemPurple
            labelTextColor = Constants.Color.systemWhite
        case .turquoise:
            backgroundColor = Constants.Color.turquoise
            labelTextColor = Constants.Color.systemWhite
        case .darkBlue:
            backgroundColor = Constants.Color.deepBlue
            labelTextColor = Constants.Color.systemWhite
        case .clear:
            backgroundColor = Constants.Color.systemWhite.withAlphaComponent(0.8)
            labelTextColor = Constants.Color.systemBlack
        case .gray:
            backgroundColor = Constants.Color.systemGray
            labelTextColor = Constants.Color.systemBlack
        case .null:
            backgroundColor = Constants.Color.systemLabel
            labelTextColor = Constants.Color.systemBackground
        }
        
        rootContainerView.backgroundColor = backgroundColor
        label.textColor = labelTextColor
        label.text = color.rawValue
    }
}

// MARK: - Layout
extension ColorCollectionViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.flex
            .cornerRadius(24.0)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(label)
                    .width(100%)
                    .height(100%)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
