//
//  MapInfoView.swift
//  HomePresentation
//
//  Created by LEEJUNHYEOK on 8/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class MapInfoView: UIView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteSemiBold(24.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteMedium(18.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteRegular(16.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupSubviewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?,
                   subtitle: String?,
                   description: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        descriptionLabel.text = description
    }
}

// MARK: - Layout
extension MapInfoView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
            rootView.addItem(subtitleLabel)
            rootView.addItem(descriptionLabel)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
