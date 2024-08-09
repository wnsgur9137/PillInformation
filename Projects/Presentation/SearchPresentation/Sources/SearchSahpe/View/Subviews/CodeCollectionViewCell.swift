//
//  CodeCollectionViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class CodeCollectionViewCell: UICollectionViewCell {
    
    private let rootContainerView = UIView()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.SearchShape.printPlaceholder
        return textField
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
    
    func textFieldDeleagte(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
}

// MARK: - Layout
extension CodeCollectionViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        rootContainerView.addSubview(textField)
        rootContainerView.flex
            .backgroundColor(Constants.Color.systemBackground)
            .cornerRadius(12.0)
            .border(0.5, Constants.Color.label)
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.top().left(12.0).right(12.0).bottom()
        textField.pin.top().left(12.0).right(12.0).bottom()
    }
}
