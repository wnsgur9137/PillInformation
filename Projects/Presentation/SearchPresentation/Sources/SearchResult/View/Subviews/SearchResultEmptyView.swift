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

import BasePresentation

final class SearchResultEmptyView: UIView {
    
    private let rootContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red.withAlphaComponent(0.4)
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = Constants.SearchResult.isEmpty
        label.textColor = Constants.Color.systemLabel
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
}

// MARK: - Layout
extension SearchResultEmptyView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(imageView)
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
