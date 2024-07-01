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
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemDarkGray
        label.font = Constants.Font.suiteMedium(18.0)
        label.numberOfLines = 0
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
        
        setupSubviewLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.bounds.size.width = size.width
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.size
    }
}

// MARK: - Layout
extension AlarmSettingTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem()
                    .margin(12.0)
                    .width(80%)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
                        labelStack.addItem(contentLabel)
                    }
                rootView.addItem(toggleButton)
                    .margin(12.0)
                    .width(20%)
                    .grow(0.5)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
