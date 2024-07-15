//
//  ShapeCollectionViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class ShapeCollectionViewCell: UICollectionViewCell {
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
    
    private func setupImageAttributedString(_ shape: SearchShapeItems) {
        guard shape != .other else { return }
        var image: UIImage?
        switch shape {
        case .rectangle: image = Constants.SearchShape.Image.rectangle
        case .oval: image = Constants.SearchShape.Image.oval
        case .circular: image = Constants.SearchShape.Image.circle
        case .semicircular: image = Constants.SearchShape.Image.semiCircle
        case .rhombus: image = Constants.SearchShape.Image.rhombus
        case .triangle: image = Constants.SearchShape.Image.triangle
        case .square: image = Constants.SearchShape.Image.square
        case .pentagon: image = Constants.SearchShape.Image.pentagon
        case .hexagon: image = Constants.SearchShape.Image.hexagon
        case .octagon: image = Constants.SearchShape.Image.octagon
        case .other: return
        }
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageAttributedString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageAttributedString)
        label.attributedText = attributedString
    }
    
    private func setupTextAttributedString(_ shape: SearchShapeItems) {
        guard shape == .other else { return }
        label.text = Constants.SearchShape.other
    }
    
    func configure(_ shape: SearchShapeItems) {
        guard shape != .other else {
            setupTextAttributedString(shape)
            return
        }
        setupImageAttributedString(shape)
    }
}

// MARK: - Layout
extension ShapeCollectionViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.flex
            .cornerRadius(24.0)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(label)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
