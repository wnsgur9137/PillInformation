//
//  ShortcutButtonCell.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

public final class ShortcutButtonCell: UICollectionViewCell {
    
    private let rootContainerView = UIView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Constants.Color.systemWhite
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = Constants.Font.suiteSemiBold(18.0)
        label.textColor = Constants.Color.systemWhite
        return label
    }()
    
    private(set) var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        layer.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func configure(_ type: HomeShortcutButtonInfo) {
        titleLabel.text = type.title
        guard let imageString = type.imageString else { return }
        var titleImage: UIImage?
        if let image = UIImage(named: imageString) {
            titleImage = image
        } else if let image = UIImage(systemName: imageString) {
            titleImage = image
        }
        titleImageView.image = titleImage
        rootContainerView.flex.layout(mode: .adjustHeight)
    }
}

// MARK: - Layout
extension ShortcutButtonCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .cornerRadius(12.0)
            .backgroundColor(Constants.Color.systemBlue)
            .alignItems(.center)
            .justifyContent(.center)
            .define { button in
                button.addItem(titleImageView)
                    .width(48.0)
                    .aspectRatio(1.0)
                button.addItem(titleLabel)
                    .marginTop(12.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
