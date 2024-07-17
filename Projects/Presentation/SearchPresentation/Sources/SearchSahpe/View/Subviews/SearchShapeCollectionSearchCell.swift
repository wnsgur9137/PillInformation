//
//  SearchShapeCollectionSearchView.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class SearchShapeCollectionSearchCell: UICollectionViewCell {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Search.search, for: .normal)
        button.setTitleColor(Constants.Color.systemWhite, for: .normal)
        button.titleLabel?.font = Constants.Font.suiteSemiBold(24.0)
        return button
    }()
    
    // MARK: - Properties
    
    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - Layout
extension SearchShapeCollectionSearchCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(searchButton)
                    .cornerRadius(12.0)
                    .backgroundColor(Constants.Color.buttonHighlightBlue)
                    .width(120.0)
                    .height(50%)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all().height(75%)
        rootContainerView.flex.layout()
    }
}
