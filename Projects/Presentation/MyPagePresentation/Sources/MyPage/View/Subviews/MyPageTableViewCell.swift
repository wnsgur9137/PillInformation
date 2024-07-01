//
//  MyPageTableViewCell.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout

import BasePresentation

final class MyPageTableViewCell: UITableViewCell {
    private let rootContainerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Constants.Font.suiteMedium(20.0)
        return label
    }()
    
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
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension MyPageTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(8.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
