//
//  PolicyCheckboxView.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/1/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class PolicyCheckboxView: UIView {
    
    // MARK: - UI Instances
    
    private let rootFlexContainerView = UIView()
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constants.OnboardingPolicy.Image.checkboxOff
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(20.0)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.OnboardingPolicy.Image.forward, for: .normal)
        button.tintColor = Constants.Color.systemLabel
        return button
    }()
    
    // MARK: - Properties
    
    var isChecked: Bool = false {
        didSet {
            checkBoxImageView.image = isChecked ? Constants.OnboardingPolicy.Image.checkboxOn : Constants.OnboardingPolicy.Image.checkboxOff
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    // MARK: - Life cycle
    
    init(hasMoreButton: Bool) {
        super.init(frame: .zero)
        setupLayout(hasMoreButton: hasMoreButton)
        
        
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
extension PolicyCheckboxView {
    private func setupLayout(hasMoreButton: Bool) {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .direction(.row)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(checkBoxImageView)
                    .margin(10)
                    .width(20.0)
                    .height(20.0)
                rootView.addItem(titleLabel)
                    .grow(1)
                if hasMoreButton {
                    rootView.addItem(seeMoreButton)
                        .width(48.0)
                }
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
