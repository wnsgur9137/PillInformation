//
//  SearchTextFieldView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 4/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout

public final class SearchTextFieldView: UIView {
    
    private let rootContainerView = UIView()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.magnifyingglass
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    public let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.font = Constants.Font.suiteMedium(14.0)
        textField.textColor = Constants.Color.systemLabel
        return textField
    }()
    
    public let shapeSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.systemBlue
        button.setImage(Constants.Image.pills, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    public let photoSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.systemBlue
        button.setImage(Constants.Image.camera, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension SearchTextFieldView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .define { rootView in
                rootView.addItem()
                    .backgroundColor(Constants.Color.systemBackground)
                    .cornerRadius(12.0)
                    .height(48.0)
                    .grow(1.0)
                    .direction(.row)
                    .define { searchView in
                        searchView.addItem(searchIconImageView)
                            .width(24.0)
                            .height(24.0)
                            .margin(12.0)
                        searchView.addItem(searchTextField)
                            .grow(1.0)
                    }
                
                rootView.addItem(shapeSearchButton)
                    .width(48.0)
                    .height(48.0)
                    .marginLeft(16.0)
                    .cornerRadius(12.0)
                
                rootView.addItem(photoSearchButton)
                    .width(48.0)
                    .height(48.0)
                    .marginLeft(8.0)
                    .cornerRadius(12.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
    }
}
