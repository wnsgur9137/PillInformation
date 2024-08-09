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
    
    static let height: CGFloat = 60.0
    
    private let rootContainerView = UIView()
    
    public lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        button.setTitleColor(Constants.Color.systemBlue, for: .normal)
        return button
    }()
    
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
        textField.textColor = Constants.Color.label
        textField.returnKeyType = .search
        return textField
    }()
    
    public let searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.systemBlue
        button.setImage(Constants.Image.magnifyingglass, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    public let shapeSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.systemBlue
        button.setImage(Constants.Image.pills, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    public init(hasDismiss: Bool = false) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: SearchTextFieldView.height))
        setupLayout(hasDismiss)
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
    private func setupLayout(_ hasDismiss: Bool) {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .padding(10.0, 24.0, 10.0, 24.0)
            .define { rootView in
                if hasDismiss {
                    rootView.addItem(dismissButton)
                        .width(36.0)
                        .height(100%)
                }
                
                rootView.addItem()
                    .backgroundColor(Constants.Color.systemBackground)
                    .border(0.5, Constants.Color.systemLightGray)
                    .cornerRadius(12.0)
                    .height(48.0)
                    .grow(1.0)
                    .direction(.row)
                    .define { searchView in
                        searchView.addItem(searchTextField)
                            .margin(0, 12.0, 0, 12.0)
                            .grow(1.0)
                        searchView.addItem(searchButton)
                            .width(36.0)
                            .height(36.0)
                            .cornerRadius(8.0)
                            .margin(6.0)
                    }
                
                rootView.addItem(shapeSearchButton)
                    .width(48.0)
                    .height(48.0)
                    .marginLeft(16.0)
                    .cornerRadius(12.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout(mode: .adjustHeight)
    }
}
