//
//  LocalizationSettingCell.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

final class LocalizationSettingCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
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
    
    func configure(title: String, isChecked: Bool) {
        titleLabel.text = title
        checkButton.isSelected = isChecked
    }
}

// MARK: - Layout
extension LocalizationSettingCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .margin(8.0)
            .direction(.row)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .grow(1.0)
                rootView.addItem(checkButton)
                    .marginLeft(12.0)
                    .height(80%)
                    .aspectRatio(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
