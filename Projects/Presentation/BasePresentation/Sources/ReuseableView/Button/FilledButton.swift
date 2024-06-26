//
//  FilledButton.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import PinLayout

public enum FilledButtonStyle {
    case large
    case medium
    
    var enableBackgroundColor: UIColor {
        return Constants.Color.systemBlue
    }
    
    var disableBackgroundColor: UIColor {
        return Constants.Color.background
    }
    
    var enableTitleColor: UIColor {
        return Constants.Color.systemWhite
    }
    
    var disableTitleColor: UIColor {
        return Constants.Color.systemLightGray
    }
    
    var selectedBackgroundColor: UIColor {
        return Constants.Color.buttonHighlightBlue
    }
    
    var selectedTitleColor: UIColor {
        return Constants.Color.systemWhite
    }
    
    var enableBorderColor: CGColor {
        return Constants.Color.systemBlue.cgColor
    }
    
    var disableBorderColor: CGColor {
        return Constants.Color.systemLightGray.cgColor
    }
}

public final class FilledButton: UIButton {
    private let style: FilledButtonStyle
    
    private var titleColor: UIColor {
        return isEnabled ? style.enableTitleColor : style.disableTitleColor
    }
    
    private var buttonBackgroundColor: UIColor {
        return isEnabled ? style.enableBackgroundColor : style.disableBackgroundColor
    }
    
    private var selectedTitleColor: UIColor {
        return style.selectedTitleColor
    }
    
    private var selectedBackgroundColor: UIColor {
        return style.selectedBackgroundColor
    }
    
    private var borderColor: CGColor {
        return isEnabled ? style.enableBorderColor : style.disableBorderColor
    }
    
    public override var isEnabled: Bool {
        didSet {
            self.buttonShadow = self.isEnabled
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
                self.backgroundColor = self.buttonBackgroundColor
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
                .foregroundColor: color,
                .font: font,
                .kern: -0.4
            ])
            self.setAttributedTitle(attributedTitle, for: .normal)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .allowUserInteraction) {
                self.backgroundColor = newValue ? self.selectedBackgroundColor : self.buttonBackgroundColor
                self.setAttributedTitle(attributedTitle, for: .normal)
            }
            super.isHighlighted = newValue
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + 48.0,
                          height: baseSize.height + 48.0)
        }
    }
    
    public lazy var cornerRadius: CGFloat = self.style == .large ? .largeButton : .mediumButton {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    public var title: String {
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
    
    public init(style: FilledButtonStyle, isEnabled: Bool = true) {
        self.style = style
        super.init(frame: .zero)
        self.isEnabled = isEnabled
        setupButton()
    }
    
    public override init(frame: CGRect) {
        self.style = .large
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.style = .large
        super.init(coder: aDecoder)
        setupButton()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
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
        backgroundColor = buttonBackgroundColor
        titleLabel?.numberOfLines = 0
        layer.cornerRadius = .largeButton / 2
        layer.borderWidth = 1.0
        layer.borderColor = borderColor
        self.buttonShadow = isEnabled
    }
    
    private func animatedToNormal() {
        UIView.animate(withDuration: 0.3) {
            self.buttonShadow = self.isEnabled
        }
    }
    
    private func setupLayout() {
        pin.height(self.style == .large ? .largeButton : .mediumButton)
    }
}
