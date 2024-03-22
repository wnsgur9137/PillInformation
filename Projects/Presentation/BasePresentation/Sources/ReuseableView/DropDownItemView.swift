//
//  DropDownItemView.swift
//  ReuseableView
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

public final class DropDownItemView: UIView {
    
    private let rootFlexContainerView = UIView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var useImageView: Bool = false
    
    public init(image: UIImage?,
         title: String) {
        super.init(frame: .zero)
        if let image = image {
            imageView.image = image
            useImageView = true
        }
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    public func configure(font: UIFont) {
        self.titleLabel.font = font
    }
}

// MARK: - Layout
extension DropDownItemView {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .direction(.row)
            .define { rootView in
                if self.useImageView {
                    rootView.addItem(imageView)
                        .height(48.0)
                        .width(48.0)
                        .margin(12.0)
                }
                
                rootView.addItem(titleLabel)
                    .margin(12.0)
                    .marginLeft(0)
                    .grow(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
