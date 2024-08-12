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
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    let searchTextFieldView = SearchTextFieldView(hasShapeSearchButton: false)
    
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
            .define { rootView in
                rootView.addItem(titleLabel)
                    .margin(12.0, 24.0, 10.0, 24.0)
                rootView.addItem(searchTextFieldView)
                    .marginBottom(12.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
