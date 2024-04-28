//
//  TimerTableViewCell.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class TimerTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(32.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OOOOOO"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(18.0)
        return label
    }()
    
    private let setTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "15:00"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(16.0)
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.bounds.size.width = size.width
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.size
    }
    
    func configure(_ timerModel: TimerModel) {
        self.titleLabel.text = timerModel.title
        self.remainingTimeLabel.text = timerModel.duration.toStringFormat()
        self.setTimeLabel.text = timerModel.duration.toStringFormat()
        
        guard let startedDate = timerModel.startedDate else { return }
        let currentDate = Date().timeIntervalSince(startedDate)
        let remainingTime = timerModel.duration - currentDate
        
        self.remainingTimeLabel.text = "\(remainingTime.toStringFormat())"
    }
}

// MARK: - Layout
extension TimerTableViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem()
                    .marginLeft(24.0)
                    .define { timeStack in
                        timeStack.addItem(remainingTimeLabel)
                        timeStack.addItem(titleLabel)
                        timeStack.addItem(setTimeLabel)
                }
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
