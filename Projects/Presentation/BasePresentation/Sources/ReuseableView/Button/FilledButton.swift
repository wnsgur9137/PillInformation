//
//  FilledButton.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

enum FilledButtonStyle {
    case large
    case medium
    
    var enableBackgroundColor: UIColor {
        return Constants.Color.systemBlue
    }
    
    var enableTitleColor: UIColor {
        return Constants.Color.systemWhite
    }
    
    var selectedBackgroundColor: UIColor {
        return Constants.Color.systemBlue // TODO: - 조금 더 어두운 블루로 변경
    }
    
    var selectedTitleColor: UIColor {
        return Constants.Color.systemWhite // TODO: - 하얀색에 가까운 하늘색으로 변경
    }
    
    var disableBackgroundColor: UIColor {
        return Constants.Color.systemWhite
    }
    
    var disableTitleColor: UIColor {
        return Constants.Color.systemLightGray
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
    
    public init(style: FilledButtonStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        self.style = .large
        super.init(frame: frame)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.style = .large
        super.init(coder: aDecoder)
    }
    
    
}
