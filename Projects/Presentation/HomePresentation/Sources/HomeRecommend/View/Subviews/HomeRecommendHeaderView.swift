//
//  HomeRecommendHeaderView.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class HomeRecommendHeaderView: UICollectionReusableView {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.numberOfLines = 1
        label.font = Constants.Font.suiteSemiBold(24.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    // MARK: - Life cycle
    
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
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - Layout
extension HomeRecommendHeaderView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(24.0, 24.0, 12.0, 24.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout(mode: .adjustHeight)
    }
}
