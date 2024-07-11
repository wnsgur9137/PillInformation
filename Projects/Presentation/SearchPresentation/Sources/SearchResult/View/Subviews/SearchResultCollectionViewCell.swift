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
import RxSwift

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
    
    private let utilView = UIView()
    
    private let hitsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.SearchResult.Image.eye
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.systemLabel
        return imageView
    }()
    
    private let hitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.SearchResult.Image.star, for: .normal)
        button.tintColor = Constants.Color.systemYellow
        return button
    }()
    
    private var isBookmarked: Bool = false {
        didSet {
            let image = isBookmarked ? Constants.SearchResult.Image.starFill : Constants.SearchResult.Image.star
            bookmarkButton.setImage(image, for: .normal)
        }
    }
    
    let disposeBag = DisposeBag()
    
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
    
    func configure(_ info: PillInfoModel, 
                   isBookmarked: Bool = false) {
        if let url = URL(string: info.medicineImage) {
            imageView.kf.setImage(with: url) { _ in
                self.imageView.hideSkeleton()
            }
        }
        titleLabel.text = info.medicineName
        classLabel.text = info.className
        etcOtcLabel.text = info.etcOtcName
        let bookmarkImage = isBookmarked ? Constants.SearchResult.Image.starFill : Constants.SearchResult.Image.star
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        titleLabel.flex.markDirty()
        classLabel.flex.markDirty()
        etcOtcLabel.flex.markDirty()
        rootFlexContainerView.flex.layout()
        
        hitsLabel.text = "\(info.hits)"
        hitsLabel.flex.markDirty()
        utilView.flex.layout()
    }
    
    func showSkeletonImageView() {
        imageView.showAnimatedGradientSkeleton()
    }
}

// MARK: - Layout
extension SearchResultCollectionViewCell {
    private func setupLayout() {
        contentView.addSubview(rootFlexContainerView)
        contentView.addSubview(utilView)
        
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
                            .width(85%)
                        labelStack.addItem().define {
                            $0.addItem(classLabel)
                            $0.addItem(etcOtcLabel)
                        }
                    }
        }
        
        utilView.flex
            .direction(.row)
            .alignItems(.center)
            .justifyContent(.end)
            .define { view in
                view.addItem().grow(1.0)
                view.addItem(hitsImageView)
                    .height(24.0)
                    .width(24.0)
                view.addItem(hitsLabel)
                    .marginLeft(4.0)
                    .height(40.0)
                view.addItem(bookmarkButton)
                    .marginLeft(12.0)
                    .width(48.0)
                    .height(48.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin
            .top(8.0)
            .left(12.0)
            .right(12.0)
            .bottom()
        rootFlexContainerView.flex.layout()
        
        utilView.pin
            .top(8.0)
            .left(40%)
            .right(12.0)
            .height(48.0)
        utilView.flex.layout()
    }
}
