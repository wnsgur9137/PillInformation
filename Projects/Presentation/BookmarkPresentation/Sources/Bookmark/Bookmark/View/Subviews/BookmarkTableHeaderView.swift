//
//  BookmarkTableHeaderView.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class BookmarkTableHeaderView: UITableViewHeaderFooterView {
    
    private let rootContainerView = UIView()
    
    let deleteButton = UIButton()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Bookmark.deleteAll
        label.textColor = Constants.Color.systemLightGray
        label.font = Constants.Font.button2
        return label
    }()
    
    private let deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Bookmark.Image.xmarkCircle
        imageView.tintColor = Constants.Color.systemLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private(set) var disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.addShadow()
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
        self.disposeBag = DisposeBag()
    }
}

// MARK: - Layout
extension BookmarkTableHeaderView {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        rootContainerView.addSubview(deleteButton)
        rootContainerView.flex
            .direction(.row)
            .margin(0, 12.0, 0, 12.0)
            .cornerRadius(12.0)
            .backgroundColor(Constants.Color.systemBackground)
        
        deleteButton.flex
            .direction(.row)
            .backgroundColor(Constants.Color.skyBlue)
            .cornerRadius(8.0)
            .define { button in
                button.addItem(deleteLabel)
                    .marginLeft(8.0)
                button.addItem(deleteImageView)
                    .marginLeft(4.0)
                    .marginRight(8.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
        deleteButton.pin.centerRight(12.0).height(32.0)
        deleteButton.flex.layout(mode: .adjustWidth)
    }
}
