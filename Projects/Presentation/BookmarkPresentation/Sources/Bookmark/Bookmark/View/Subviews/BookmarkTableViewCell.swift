//
//  BookmarkTableViewCell.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout
import Kingfisher
import SkeletonView

import BasePresentation

final class BookmarkTableViewCell: UITableViewCell {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(20.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    private let etcOtcLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(16.0)
        return label
    }()
    
    private let utilView = UIView()
    
    private let hitsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.eye
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.label
        return imageView
    }()
    
    private let hitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.star, for: .normal)
        button.tintColor = Constants.Color.systemYellow
        return button
    }()
    
    private var isBookmarked: Bool = false {
        didSet {
            let image = isBookmarked ? Constants.Image.starFill : Constants.Image.star
            bookmarkButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.addShadow()
        backgroundColor = Constants.Color.background
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
        disposeBag = DisposeBag()
        setupSubviewLayout()
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        rootContainerView.isSkeletonable = true
        pillImageView.isSkeletonable = true
    }
    
    func configure(_ info: PillInfoModel,
                   isBookmarked: Bool = true) {
        if let url = URL(string: info.medicineImage) {
            pillImageView.kf.setImage(with: url) { _ in
                self.pillImageView.hideSkeleton()
            }
        }
        titleLabel.text = info.medicineName
        classLabel.text = info.className
        etcOtcLabel.text = info.etcOtcName
        let bookmarkImage = isBookmarked ? Constants.Image.starFill : Constants.Image.star
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        titleLabel.flex.markDirty()
        classLabel.flex.markDirty()
        etcOtcLabel.flex.markDirty()
        rootContainerView.flex.layout()
        
        hitsLabel.text = "\(info.hits)"
        hitsLabel.flex.markDirty()
        utilView.flex.layout()
    }
    
    func showSkeletonImageView() {
        pillImageView.showAnimatedGradientSkeleton()
    }
}

// MARK: - Layout
extension BookmarkTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        contentView.addSubview(utilView)
        
        rootContainerView.flex
            .alignItems(.center)
            .direction(.row)
            .padding(4.0)
            .border(0.5, Constants.Color.systemLightGray)
            .backgroundColor(Constants.Color.systemBackground)
            .cornerRadius(12.0)
            .define { rootView in
                rootView.addItem(pillImageView)
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
                            .shrink(1.0)
                            .width(85%)
                        labelStack.addItem().define {
                            $0.addItem(classLabel)
                            $0.addItem(etcOtcLabel)
                        }
                    }
                rootView.addItem(bookmarkButton)
                    .marginLeft(12.0)
                    .width(48.0)
                    .height(48.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin
            .top(8.0)
            .left(12.0)
            .right(12.0)
            .bottom()
        rootContainerView.flex.layout()
        
        utilView.pin
            .top(8.0)
            .left(40%)
            .right(12.0)
            .height(48.0)
        utilView.flex.layout()
    }
}

