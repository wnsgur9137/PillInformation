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

import BasePresentation

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    private let rootFlexContainerView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(20.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(16.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let etcOtcLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(18.0)
        label.numberOfLines = 0
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
        setupSubviewLayout()
    }
    
    override func prepareForReuse() {
        setupSubviewLayout()
    }
    
    func configure(_ info: PillInfoModel) {
        if let url = URL(string: info.medicineImage) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = info.medicineName
        classLabel.text = info.className
        etcOtcLabel.text = info.etcOtcName
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
            .border(1.0, Constants.Color.systemLightGray)
            .padding(12.0)
            .define { rootView in
                rootView.addItem(imageView)
                    .width(30%)
                    .height(100%)
                rootView.addItem()
                    .width(70%)
                    .height(100%)
                    .marginLeft(12.0)
                    .justifyContent(.center)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
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
