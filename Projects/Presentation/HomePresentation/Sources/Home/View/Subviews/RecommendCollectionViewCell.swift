//
//  RecommendCollectionViewCell.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import Kingfisher

import BasePresentation

final class RecommendCollectionViewCell: UICollectionViewCell {
    
    private let rootContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(18.0)
        label.numberOfLines = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(12.0)
        label.clipsToBounds = true
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
    
    func configure(_ pillInfo: PillInfoModel) {
        imageView.kf.setImage(with: URL(string: pillInfo.medicineImage))
        imageView.clipsToBounds = true
        titleLabel.text = pillInfo.medicineName
        classLabel.text = pillInfo.className
        rootContainerView.flex.layout()
    }
}

// MARK: - Layout
extension RecommendCollectionViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .cornerRadius(24.0)
            .margin(12.0)
            .backgroundColor(Constants.Color.background)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(imageView)
                    .marginTop(12.0)
                    .marginBottom(12.0)
                    .width(90%)
                    .aspectRatio(1.0)
                    .cornerRadius(12.0)
                rootView.addItem()
                    .margin(8.0)
                    .width(90%)
                    .grow(1.0)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
                        labelStack.addItem(classLabel)
                    }
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
