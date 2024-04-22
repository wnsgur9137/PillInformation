//
//  NoticeTableViewCell.swift
//  Home
//
//  Created by JunHyeok Lee on 2/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

final class NoticeTableViewCell: UITableViewCell {
    
    // MARK: - UI Instances
    
    private let rootFlexContainerView = UIView()
    private let titleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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

extension NoticeTableViewCell {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension NoticeTableViewCell {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .justifyContent(.center)
            .define { rootView in
            rootView.addItem(titleLabel)
                    .margin(UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0))
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
