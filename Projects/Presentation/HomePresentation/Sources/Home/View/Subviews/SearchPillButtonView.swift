//
//  SearchPillButtonView.swift
//  Home
//
//  Created by JunHyeok Lee on 2/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class SearchPillButtonView: UIView {
    
    private let rootFlexContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.label
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteMedium(16.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let button = UIButton()
    
    // MARK: - Life Cycle
    
    init(image: UIImage?, title: String?) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension SearchPillButtonView {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        addSubview(button)
        
        rootFlexContainerView.flex
            .width(120.0)
            .height(120.0)
            .padding(4.0)
            .cornerRadius(16.0)
            .border(2.0, Constants.Color.label)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(imageView)
                    .width(70.0)
                    .height(70.0)
                rootView.addItem(titleLabel)
                    .marginLeft(2.0)
                    .marginRight(2.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
        button.pin.all()
    }
}
