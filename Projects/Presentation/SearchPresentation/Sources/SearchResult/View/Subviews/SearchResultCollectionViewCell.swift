//
//  SearchResultCollectionViewCell.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import Kingfisher
import SkeletonView

import BasePresentation

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    private let rootFlexContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(20.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    private let etcOtcLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(16.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addShadow()
        setupSkeletonable()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupSubviewLayout()
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        rootFlexContainerView.isSkeletonable = true
        imageView.isSkeletonable = true
    }
    
    func configure(_ info: PillInfoModel) {
        if let url = URL(string: info.medicineImage) {
            imageView.kf.setImage(with: url) { _ in
                self.imageView.hideSkeleton()
            }
        }
        titleLabel.text = info.medicineName
        classLabel.text = info.className
        etcOtcLabel.text = info.etcOtcName
        titleLabel.flex.markDirty()
        classLabel.flex.markDirty()
        etcOtcLabel.flex.markDirty()
        rootFlexContainerView.flex.layout()
    }
    
    func showSkeletonImageView() {
        imageView.showAnimatedGradientSkeleton()
    }
}

// MARK: - Layout
extension SearchResultCollectionViewCell {
    private func setupLayout() {
        contentView.addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .alignItems(.center)
            .direction(.row)
            .cornerRadius(12.0)
            .padding(4.0)
            .border(0.5, Constants.Color.systemLightGray)
            .backgroundColor(Constants.Color.systemBackground)
            .define { rootView in
                rootView.addItem(imageView)
                    .height(100%)
                    .aspectRatio(1)
                    .cornerRadius(12.0)
                
                rootView.addItem()
                    .grow(1)
                    .shrink(1)
                    .marginLeft(24.0)
                    .marginRight(18.0)
                    .justifyContent(.center)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
                            .width(100%)
                        labelStack.addItem().define {
                            $0.addItem(classLabel)
                            $0.addItem(etcOtcLabel)
                        }
                    }
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin
            .top(8.0)
            .left(12.0)
            .right(12.0)
            .bottom()
        rootFlexContainerView.flex.layout()
    }
}
