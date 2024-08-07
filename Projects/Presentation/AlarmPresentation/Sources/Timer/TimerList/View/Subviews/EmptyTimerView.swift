//
//  EmptyTimerView.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class EmptyTimerView: UIView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.AlarmViewController.emptyAlarm
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    private let addTimerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.AlarmViewController.addTimer, for: .normal)
        button.setTitleColor(Constants.Color.label, for: .normal)
        button.titleLabel?.font = Constants.Font.suiteBold(14.0)
        return button
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
}

// MARK: - Layout
extension EmptyTimerView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                
                rootView.addItem(addTimerButton)
                    .border(1.0, Constants.Color.systemLightGray)
                    .backgroundColor(Constants.Color.systemBlue)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all().height(120.0)
        rootContainerView.flex.layout()
    }
}
