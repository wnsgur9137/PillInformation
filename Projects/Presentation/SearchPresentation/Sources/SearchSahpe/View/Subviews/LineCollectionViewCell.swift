//
//  LineCollectionViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class LineCollectionViewCell: UICollectionViewCell {
    private let rootContainerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(24.0)
        return label
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
    
    private func setupImageAttributedString(_ line: SearchLineItems) {
        guard line == .minuse || line == .plus else { return }
        let image = line == .minuse ? Constants.SearchShape.Image.minus : Constants.SearchShape.Image.plus
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageAttributedString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageAttributedString)
        label.attributedText = attributedString
    }
    
    private func setupTextAttributedString(_ line: SearchLineItems) {
        guard line == .other || line == .null else { return }
        let text = line == .other ? Constants.SearchShape.other : Constants.SearchShape.null
        label.text = text
    }
    
    func configure(_ line: SearchLineItems) {
        switch line {
        case .minuse: fallthrough
        case .plus: setupImageAttributedString(line)
        case .other: fallthrough
        case .null: setupTextAttributedString(line)
        }
    }
}

// MARK: - Layout
extension LineCollectionViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.flex
            .cornerRadius(24.0)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(label)
                    .margin(12.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
