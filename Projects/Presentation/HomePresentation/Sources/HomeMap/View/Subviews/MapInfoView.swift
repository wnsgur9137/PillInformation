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
        label.text = "TEST Title"
        label.font = Constants.Font.suiteSemiBold(32.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST Subtitle"
        label.font = Constants.Font.suiteMedium(18.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let routeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Home.findRoute
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteSemiBold(22.0)
        return label
    }()
    
    let walkButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Home.walk, for: .normal)
        button.titleLabel?.textColor = Constants.Color.systemWhite
        button.titleLabel?.font = Constants.Font.suiteMedium(16.0)
        button.backgroundColor = Constants.Color.systemBlue
        return button
    }()
    
    let vehicleButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Home.vehicle, for: .normal)
        button.titleLabel?.textColor = Constants.Color.systemWhite
        button.titleLabel?.font = Constants.Font.suiteMedium(16.0)
        button.backgroundColor = Constants.Color.systemBlue
        return button
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
                   subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - Layout
extension MapInfoView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .backgroundColor(Constants.Color.background)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .margin(12.0, 12.0, 8.0, 12.0)
                rootView.addItem(subtitleLabel)
                    .margin(0, 12.0, 12.0, 12.0)
                
                rootView.addItem(routeLabel)
                    .margin(12.0, 12.0, 8.0, 12.0)
                rootView.addItem()
                    .width(100%)
                    .direction(.row)
                    .define { buttonStack in
                        buttonStack.addItem(walkButton)
                            .margin(8.0)
                            .grow(1.0)
                        buttonStack.addItem(vehicleButton)
                            .margin(8.0)
                            .grow(1.0)
                    }
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
