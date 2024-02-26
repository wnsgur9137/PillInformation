//
//  SearchRecentCollectionViewCell.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import Common

final class SearchRecentCollectionViewCell: UICollectionViewCell {
    
    private let rootFlexContainerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(20.0)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
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
    }
}

// MARK: - Layout
extension SearchRecentCollectionViewCell {
    private func setupLayout() {
        let height: CGFloat = 40.0
        contentView.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .height(height)
            .cornerRadius(height / 2)
            .backgroundColor(Constants.Color.systemBackground)
            .justifyContent(.center)
            .define { rootView in
            rootView.addItem(label)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
