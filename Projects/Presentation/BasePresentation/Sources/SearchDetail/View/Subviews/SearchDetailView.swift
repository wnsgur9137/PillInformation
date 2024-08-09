//
//  SearchDetailView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import FlexLayout
import PinLayout
import Kingfisher

public final class SearchDetailView: UIView {
    
    private let rootContainerView = UIView()
    public let navigationView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var capsuleView: CapsuleView?
    
    public let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.label
        button.setTitleColor(Constants.Color.systemBlue, for: .normal)
        return button
    }()
    
    public let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(18.0)
        label.numberOfLines = 2
        label.alpha = 0
        return label
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public let contentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInset = .zero
        return tableView
    }()
    
    public init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension SearchDetailView {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        rootContainerView.addSubview(navigationView)
        rootContainerView.addSubview(navigationTitleLabel)
        rootContainerView.addSubview(dismissButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentTableView)
        
        contentView.flex.define { contentView in
            contentView.addItem(contentTableView)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        navigationTitleLabel.pin.top(safeAreaInsets.top).left().right().height(48.0)
        dismissButton.pin
            .centerLeft(to: navigationTitleLabel.anchor.centerLeft).marginLeft(12.0)
            .width(48.0)
            .height(48.0)
        navigationView.pin.top().left().right().bottom(to: navigationTitleLabel.edge.bottom)
        scrollView.pin.top().horizontally().bottom()
        scrollView.flex.layout()
        contentView.pin.top(to: rootContainerView.edge.top).horizontally()
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    public func updateSubviewLayout() {
        contentTableView.flex.layout()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
