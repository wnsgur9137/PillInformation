//
//  BookmarkSearchView.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class BookmarkHeaderView: UIView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Bookmark.bookmark
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.magnifyingglass
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "즐겨찾기에서 검색"
        textField.font = Constants.Font.suiteMedium(14.0)
        textField.tintColor = Constants.Color.systemWhite
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
}

// MARK: - Layout
extension BookmarkHeaderView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .backgroundColor(Constants.Color.systemBackground)
            .padding(10.0, 24.0, 10.0, 24.0)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .margin(12.0)
                
                rootView.addItem()
                    .backgroundColor(Constants.Color.systemBackground)
                    .border(0.5, Constants.Color.systemLightGray)
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
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
