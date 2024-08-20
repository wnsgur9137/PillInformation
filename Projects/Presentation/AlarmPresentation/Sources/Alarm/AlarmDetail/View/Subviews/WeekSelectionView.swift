//
//  WeekSelectionView.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class WeekSelectionView: UIView {
    
    private let rootContainerView = UIView()
    
    let sundayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.sundayShort, for: .normal)
        return button
    }()
    
    let mondayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.mondayShort, for: .normal)
        return button
    }()
    
    let tuesdayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.tuesdayShort, for: .normal)
        return button
    }()
    
    let wednesdayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.wednesdayShort, for: .normal)
        return button
    }()
    
    let thursdayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.thursdayShort, for: .normal)
        return button
    }()
    
    let fridayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.fridayShort, for: .normal)
        return button
    }()
    
    let saturdayButton: WeekButton = {
        let button = WeekButton()
        button.setTitle(Constants.Alarm.saturdayShort, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
extension WeekSelectionView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .margin(5.0)
            .direction(.row)
            .alignItems(.center)
            .justifyContent(.spaceBetween)
            .define { rootView in
                rootView.addItem(sundayButton).width(10%)
                rootView.addItem(mondayButton).width(10%)
                rootView.addItem(tuesdayButton).width(10%)
                rootView.addItem(wednesdayButton).width(10%)
                rootView.addItem(thursdayButton).width(10%)
                rootView.addItem(fridayButton).width(10%)
                rootView.addItem(saturdayButton).width(10%)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}

final class WeekButton: UIButton {
    
    private let selectedColor: UIColor = Constants.Color.systemBlue
    private let unselectedColor: UIColor = Constants.Color.systemLightGray
    
    override var isSelected: Bool {
        didSet {
            let color = isSelected ? selectedColor : unselectedColor
            tintColor = color
            setTitleColor(color, for: .normal)
            layer.borderColor = color.cgColor
        }
    }
    
    init(isSelected: Bool = false) {
        super.init(frame: .zero)
        self.isSelected = isSelected
        titleLabel?.font = Constants.Font.suiteMedium(24.0)
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
