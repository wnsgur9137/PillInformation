//
//  AlarmTableHeaderView.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class AlarmTableHeaderView: UITableViewHeaderFooterView {
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.AlarmViewController.alarm
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(24.0)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.plus, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        return button
    }()
    
    private(set) var disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Color.background
        rootContainerView.backgroundColor = Constants.Color.background
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
extension AlarmTableHeaderView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .marginLeft(24.0)
                    .grow(1)
                rootView.addItem(addButton)
                    .width(48.0)
                    .height(48.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
