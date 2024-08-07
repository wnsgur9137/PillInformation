//
//  CapsuleView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

public final class CapsuleView: UIView {
    
    private let rootContainerView = UIView()
    
    public let minWidth: CGFloat = 180.0
    public let height: CGFloat = 60.0
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.pasteboard
        imageView.tintColor = Constants.Color.systemWhite
        imageView.contentMode = .scaleAspectFit
        // TODO: - 17.0 이상으로 올린 후 bounce 추가
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    public init(_ text: String? = nil) {
        super.init(frame: .zero)
        setupLayout()
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension CapsuleView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .justifyContent(.center)
            .alignItems(.center)
            .margin(8.0)
            .backgroundColor(Constants.Color.systemDarkGray.withAlphaComponent(0.8))
            .cornerRadius(20.0)
            .define { rootView in
                rootView.addItem(imageView)
                    .width(48.0)
                    .height(48.0)
                
                rootView.addItem(label)
                    .marginLeft(16.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
