//
//  TimerTableViewHeaderView.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class TimerTableViewHeaderView: UITableViewHeaderFooterView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.TimerViewController.timer
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(24.0)
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.plus, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Color.background
        rootContainerView.backgroundColor = Constants.Color.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isOperationHeader: Bool = false) {
        setupLayout(isOperationHeader)
        
        titleLabel.text = isOperationHeader ? Constants.TimerViewController.timer : Constants.TimerViewController.recentTimer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension TimerTableViewHeaderView {
    private func setupLayout(_ isOperationHeader: Bool) {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .marginLeft(24.0)
                    .grow(1)
                if isOperationHeader {
                    rootView.addItem(addButton)
                        .width(48.0)
                        .height(48.0)
                }
        }
        
        rootContainerView.addSubview(titleLabel)
        rootContainerView.addSubview(addButton)
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}