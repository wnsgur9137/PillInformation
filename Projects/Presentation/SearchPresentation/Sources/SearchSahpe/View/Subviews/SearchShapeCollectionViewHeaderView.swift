//
//  SearchShapeCollectionViewHeaderView.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class SearchShapeCollectionViewHeaderView: UICollectionReusableView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteBold(32.0)
        label.textColor = Constants.Color.label
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
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension SearchShapeCollectionViewHeaderView {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.addSubview(titleLabel)
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        titleLabel.pin
            .left(24.0)
            .right(12.0)
            .bottom()
            .height(80%)
    }
}
