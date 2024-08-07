//
//  OutlineButton.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public enum OutlineButtonStyle {
    case defaultLarge
    case defaultMedium
    case primaryLarge
    case primaryMedium
    
    var enableBorderColor: CGColor {
        switch self {
        case .defaultLarge, .defaultMedium: 
            return Constants.Color.label.cgColor
        case .primaryLarge, .primaryMedium: 
            return Constants.Color.systemBlue.cgColor
        }
    }
    
    var disableBorderColor: CGColor {
        return Constants.Color.systemLightGray.cgColor
    }
    
    var selectedBorderColor: CGColor {
        switch self {
        case .defaultLarge, .defaultMedium: 
            return Constants.Color.label.cgColor
        case .primaryLarge, .primaryMedium: 
            return Constants.Color.buttonHighlightBlue.cgColor
        }
    }
    
    var backgroundColor: UIColor {
        return Constants.Color.systemBackground
    }
    
    var selectedBackgroundColor: UIColor {
        return Constants.Color.systemLightGray
    }
    
    var enableTitleColor: UIColor {
        switch self {
        case .defaultLarge, .defaultMedium: 
            return Constants.Color.label
        case .primaryLarge, .primaryMedium: 
            return Constants.Color.systemBlue
        }
    }
    
    var disableTitleColor: UIColor {
        return Constants.Color.systemLightGray
    }
    
    var selectedTitleColor: UIColor {
        switch self {
        case .defaultLarge, .defaultMedium: 
            return Constants.Color.systemDarkGray
        case .primaryLarge, .primaryMedium: 
            return Constants.Color.buttonHighlightBlue
        }
    }
    
}

public final class OutlineButton: UIButton {
    private let style: OutlineButtonStyle
    
    private var titleColor: UIColor {
        isEnabled ? style.enableTitleColor : style.disableTitleColor
    }
    private var borderColor: CGColor {
        isEnabled ? style.enableBorderColor : style.disableBorderColor
    }
    private lazy var buttonBackgroundColor: UIColor = style.backgroundColor
    private lazy var selectedTitleColor: UIColor = style.selectedTitleColor
    private lazy var selectedBorderColor: CGColor = style.selectedBorderColor
    private lazy var selectedBackgroundColor: UIColor = style.selectedBackgroundColor
    
    public override var isEnabled: Bool {
        didSet {
            let currentTitle = self.attributedTitle(for: .normal)?.string ?? ""
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let font = Constants.Font.suiteSemiBold(17.0)
            let attributedTitle = NSAttributedString(string: currentTitle, attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.titleColor,
                .font: font,
                .kern: -0.4
            ])
            self.setAttributedTitle(attributedTitle, for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.layer.borderColor = self.borderColor
            }
        }
    }
    
    public override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            let color: UIColor = newValue ? selectedTitleColor : titleColor
            let currentTitle = self.attributedTitle(for: .normal)?.string ?? ""
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let font = Constants.Font.suiteSemiBold(17.0)
            let attributedTitle = NSAttributedString(string: currentTitle, attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.titleColor,
                .font: font,
                .kern: -0.4
            ])
            self.setAttributedTitle(attributedTitle, for: .normal)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .allowUserInteraction,
                           animations: {
                self.layer.borderColor = newValue ? self.selectedBorderColor : self.borderColor
                self.setAttributedTitle(attributedTitle, for: .normal)
            })
            super.isHighlighted = newValue
        }
    }
    
    lazy var cornerRaidus: CGFloat = self.style == .defaultLarge || self.style == .primaryLarge ? .largeButton : .mediumButton {
        didSet {
            layer.cornerRadius = cornerRaidus
        }
    }
    
    var title: String {
        get {
            "\(self.titleLabel?.attributedText ?? .init(string: ""))"
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let font = Constants.Font.suiteSemiBold(17.0)
            let attributedTitle = NSAttributedString(string: newValue, attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.titleColor,
                .font: font,
                .kern: -0.4
            ])
            self.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    // MARK: - init
    
    public init(style: OutlineButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        setupButton()
    }
    
    public override init(frame: CGRect) {
        self.style = .defaultLarge
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.style = .defaultLarge
        super.init(coder: aDecoder)
        setupButton()
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
            self.buttonShadow = false
        })
        return super.beginTracking(touch, with: event)
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animatedToNormal()
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animatedToNormal()
    }
    
    private func setupButton() {
        backgroundColor = backgroundColor
        self.layer.cornerRadius = self.frame.height / 2
        self.buttonShadow = isEnabled
    }
    
    private func animatedToNormal() {
        UIView.animate(withDuration: 0.3) {
            self.buttonShadow = self.isEnabled
        }
    }
}
