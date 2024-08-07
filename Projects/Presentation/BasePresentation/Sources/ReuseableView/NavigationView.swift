//
//  NavigationView.swift
//  ReuseableView
//
//  Created by JunHyeok Lee on 2/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

public final class NavigationView: UIView {
    private let rootFlexContainerView = UIView()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        return button
    }()
    
    private let titleView = UIView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.image = Constants.NavigationView.Image.titleImage
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(24.0)
        return label
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants.Color.systemLightGray
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    public lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.NavigationView.search, for: .normal)
        button.setTitleColor(Constants.Color.label, for: .normal)
        return button
    }()
    
    private let useTextField: Bool
    private let isShowBackwardButton: Bool
    private let titleHeight: CGFloat = 45.0
    private let searchHeight: CGFloat = 40.0
    public private(set) lazy var height: CGFloat = titleHeight
    
    public init(useTextField: Bool,
                isShowBackwardButton: Bool = false) {
        self.useTextField = useTextField
        self.isShowBackwardButton = isShowBackwardButton
        super.init(frame: .zero)
        if useTextField { self.height += searchHeight }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    public func setupBackwardButton(_ action: UIAction) {
        guard isShowBackwardButton else { return }
        backwardButton.addAction(action, for: .touchUpInside)
    }
}

// MARK: - Layout
extension NavigationView {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        if isShowBackwardButton {
            addSubview(backwardButton)
        }
        
        rootFlexContainerView.flex
            .backgroundColor(Constants.Color.systemBackground)
            .define { rootView in
                rootView.addItem(titleView)
                    .direction(.row)
                    .height(titleHeight)
                    .justifyContent(.center)
                    .define { titleStack in
                        titleStack.addItem(titleImageView)
                            .height(24.0)
                            .width(24.0)
                            .margin(8.0)
                        titleStack.addItem(titleLabel)
                            .margin(8.0)
                            .marginLeft(0)
                    }
                
                if useTextField {
                    rootView.addItem()
                        .direction(.row)
                        .height(searchHeight)
                        .define { searchStack in
                            searchStack.addItem(textField)
                                .margin(UIEdgeInsets(top: 4.0, left: 8.0, bottom: 8.0, right: 4.0))
                                .grow(1.0)
                            searchStack.addItem(searchButton)
                                .margin(UIEdgeInsets(top: 4.0, left: 4.0, bottom: 8.0, right: 8.0))
                        }
                }
                
                rootView.addItem()
                    .height(1)
                    .backgroundColor(Constants.Color.systemBlack)
            }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
        pin.height(height)
        if isShowBackwardButton {
            backwardButton.pin
                .centerLeft(to: titleView.anchor.centerLeft)
                .marginLeft(8.0)
                .width(24.0)
                .height(24.0)
        }
    }
}

#if DEBUG
import SwiftUI
struct Preview: PreviewProvider {
    static var previews: some View {
        NavigationView(useTextField: true).toPreview()
    }
}
#endif
