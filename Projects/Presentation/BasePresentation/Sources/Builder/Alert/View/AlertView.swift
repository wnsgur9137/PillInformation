//
//  AlertView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Lottie
import FlexLayout
import PinLayout

public final class AlertView: UIView {
    private let rootFlexContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Color.systemWhite
        view.layer.cornerRadius = 24.0
        view.layer.addShadow()
        return view
    }()
    
    private let labelContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let confirmButton: FilledButton = {
        let button = FilledButton(style: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: OutlineButton = {
        let button = OutlineButton(style: .defaultLarge)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var checkedViews: [Bool] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

extension AlertView {
    func setup(popupImageName: String) {
        guard let image = UIImage(named: popupImageName) else { return }
        popupImageView.image = image
        setupPopupImageLayout()
    }
    
    func setup(popupImage: UIImage) {
        popupImageView.image = popupImage
        setupPopupImageLayout()
    }
    
    func addTitleLabel(_ text: String) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.font = Constants.Font.suiteBold(14.0)
        labelContainerView.flex.addItem(titleLabel)
    }
    
    func addTitleLabel(_ attributedString: NSAttributedString) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedString
        labelContainerView.flex.addItem(titleLabel)
    }
    
    func addMessageLabel(_ text: String) {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.text = text
        messageLabel.font = Constants.Font.suiteRegular(12.0)
        labelContainerView.flex.addItem(messageLabel)
    }
    
    func addMessageLabel(_ attributedString: NSAttributedString) {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.attributedText = attributedString
        labelContainerView.flex.addItem(messageLabel)
    }
    
    func setupCancelButton() {
        buttonContainerView.flex.addItem(cancelButton)
    }
    
    func updateLayout() {
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension AlertView {
    private func setupDefaultLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .padding(32.0, 24.0, 32.0, 24.0)
            .define { rootView in
            rootView.addItem(labelContainerView)
            rootView.addItem(buttonContainerView)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
        
        labelContainerView.flex.layout()
        buttonContainerView.flex.layout()
    }
    
    private func setupPopupImageLayout() {
        addSubview(popupImageView)
        popupImageView.centerXAnchor.constraint(equalTo: rootFlexContainerView.centerXAnchor).isActive = true
        popupImageView.bottomAnchor.constraint(equalTo: rootFlexContainerView.topAnchor).isActive = true
        popupImageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        popupImageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
    }
}
