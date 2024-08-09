//
//  RecentTableViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class RecentTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    private(set) var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteMedium(14.0)
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.xmark, for: .normal)
        button.tintColor = Constants.Color.label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.bounds.size.width = size.width
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.size
    }
    
    func configure(text: String) {
        titleLabel.text = text
        titleLabel.flex.markDirty()
        setupSubviewLayout()
    }
}

extension RecentTableViewCell {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        rootContainerView.flex
            .padding(12.0)
            .direction(.row)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .width(85%)
                    .minHeight(40.0)
                    .shrink(1.0)
                rootView.addItem(deleteButton)
                    .width(15%)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
