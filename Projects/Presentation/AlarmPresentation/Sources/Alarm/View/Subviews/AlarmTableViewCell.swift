//
//  AlarmTableViewCell.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

final class AlarmTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "20:00"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(32.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "000000"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(18.0)
        return label
    }()
    
    let toggleButton: UISwitch = {
        let toggleButton = UISwitch()
        toggleButton.isOn = true
        toggleButton.onTintColor = Constants.Color.systemBlue
        return toggleButton
    }()
    
    private(set) var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.bounds.size.width = size.width
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.size
    }

    func confgure(_ alarmModel: AlarmModel) {
        self.titleLabel.text = alarmModel.title
    }
}

// MARK: - Layout
extension AlarmTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem()
                    .marginLeft(24.0)
                    .grow(1.0)
                    .define { timeStack in
                        timeStack.addItem(timeLabel)
                        timeStack.addItem(titleLabel)
                    }
                rootView.addItem(toggleButton)
                    .marginRight(24.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
