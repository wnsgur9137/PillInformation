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
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.warningMessage
        label.textColor = Constants.Color.systemLightGray
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
            .height(100)
            .define { rootView in
            
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}

#if DEBUG
import SwiftUI
struct Preview: PreviewProvider {
    static var previews: some View {
        FooterView().toPreview()
    }
}
#endif
