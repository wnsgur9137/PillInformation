//
//  FooterView.swift
//  ReuseableView
//
//  Created by JUNHYEOK LEE on 2/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Common
import FlexLayout
import PinLayout

public final class FooterView: UIView {
    private let rootFlexContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteSemiBold(18.0)
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.warningMessage
        label.textColor = Constants.Color.systemWhite
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = Constants.Color.darkBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Layout
extension FooterView {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex
            .padding(UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
            .define { rootView in
                rootView.addItem(titleLabel)
                rootView.addItem()
                    .backgroundColor(Constants.Color.systemWhite)
                    .height(1)
                    .marginTop(6.0)
                rootView.addItem(warningLabel)
                    .marginTop(6.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}

//#if DEBUG
//import SwiftUI
//struct Preview: PreviewProvider {
//    static var previews: some View {
//        FooterView().toPreview()
//    }
//}
//#endif
