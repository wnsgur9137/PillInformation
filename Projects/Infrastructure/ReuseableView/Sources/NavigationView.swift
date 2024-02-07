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
import Common

public final class NavigationView: UIView {
    private let rootFlexContainerView = UIView()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = Constants.Image.
        return imageView
    }()
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = Constants.Color.systemBackground
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
extension NavigationView {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex.define { rootView in
            
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
        NavigationView().toPreview()
    }
}
#endif
