//
//  HealthAuthView.swift
//  HealthPresentation
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

public final class HealthAuthView: UIView {
    private let rootContainerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "권한이 필요합니다."
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(24.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "어쩌저쩌\n저쩌저쩌\n어쩌어쩌"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(12.0)
        label.numberOfLines = 0
        return label
    }()
    
    let authButton: FilledButton = {
        let button = FilledButton(style: .medium)
        button.title = "권한 허용"
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow.withAlphaComponent(0.2)
        setupLayout()
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
extension HealthAuthView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        flex.cornerRadius(8.0)
        
        rootContainerView.flex
            .margin(12.0)
            .define { rootView in
            rootView.addItem(titleLabel)
            rootView.addItem(descriptionLabel)
            rootView.addItem()
                .direction(.row)
                .define {
                    $0.addItem()
                        .grow(1.0)
                    $0.addItem(authButton)
                        .width(80.0)
                }
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout(mode: .adjustHeight)
    }
}
