//
//  AlertView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Lottie

public final class AlertView: UIView {
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24.0
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8.0
        return stackView
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
        
        backgroundColor = Constants.Color.systemBackground
        layer.cornerRadius = 24.0
        layer.addShadow()
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertView {
    func setup(popupImageName: String) {
        guard let image = UIImage(named: popupImageName) else { return }
        popupImageView.image = image
        setupImageViewLayout()
    }
    
    func setup(popupImage: UIImage) {
        popupImageView.image = popupImage
        setupImageViewLayout()
    }
    
    func addTitleLabel(_ text: String) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.font = Constants.Font.suiteBold(24.0)
        labelStackView.addArrangedSubview(titleLabel)
    }
    
    func addTitleLabel(_ attributedString: NSAttributedString) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedString
        labelStackView.addArrangedSubview(titleLabel)
    }
    
    func addMessageLabel(_ text: String) {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.text = text
        messageLabel.font = Constants.Font.suiteRegular(18.0)
        labelStackView.addArrangedSubview(messageLabel)
    }
    
    func addMessageLabel(_ attributedString: NSAttributedString) {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.attributedText = attributedString
        labelStackView.addArrangedSubview(messageLabel)
    }
    
    func setupCancelButton() {
        buttonStackView.addArrangedSubview(cancelButton)
    }
}

// MARK: - Layout
extension AlertView {
    private func addSubviews() {
        addSubview(rootStackView)
        rootStackView.addArrangedSubview(labelStackView)
        rootStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(confirmButton)
        confirmButton.backgroundColor = .yellow.withAlphaComponent(0.3)
    }
    
    private func setupLayoutConstraints() {
        rootStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0).isActive = true
        rootStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24.0).isActive = true
        rootStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0).isActive = true
        rootStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0).isActive = true
    }
    
    private func setupImageViewLayout() {
        addSubview(popupImageView)
        popupImageView.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        popupImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
