//
//  AlarmSettingTableViewCell.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout

import BasePresentation

final class AlarmSettingTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(24.0)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(18.0)
        return label
    }()
    
    let toggleButton: UISwitch = {
        let button = UISwitch()
        return button
    }()
    
    func configure(_ contents: AlarmSettingCellInfo) {
        titleLabel.text = contents.title
        contentLabel.text = contents.content
        toggleButton.isOn = contents.isAgree
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
extension AlarmSettingTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .define { rootView in
            rootView.addItem()
                .grow(1.0)
                .define { labelStack in
                    labelStack.addItem(titleLabel)
                    labelStack.addItem(contentLabel)
                }
            rootView.addItem(toggleButton)
                .alignSelf(.center)
                .width(144.0)
                .height(144.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
