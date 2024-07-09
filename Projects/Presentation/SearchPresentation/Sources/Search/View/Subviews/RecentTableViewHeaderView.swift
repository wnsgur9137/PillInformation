//
//  RecentTableViewHeaderView.swift
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

final class RecentTableViewHeaderView: UITableViewHeaderFooterView {
    
    private let rootContainerView = UIView()
    private(set) var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Search.recentKeyword
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(24.0)
        return label
    }()
    
    let deleteAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 삭제", for: .normal)
        button.setTitleColor(Constants.Color.systemLabel, for: .normal)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        rootContainerView.backgroundColor = Constants.Color.systemBackground
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
        setupSubviewLayout()
    }
}

extension RecentTableViewHeaderView {
    private func setupLayout() {
        contentView.addSubview(rootContainerView)
        rootContainerView.flex
            .direction(.row)
            .justifyContent(.center)
            .padding(12.0)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .width(80%)
                    .minHeight(60.0)
                rootView.addItem(deleteAllButton)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
