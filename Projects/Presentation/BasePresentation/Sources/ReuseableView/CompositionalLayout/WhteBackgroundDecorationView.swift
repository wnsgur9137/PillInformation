//
//  WhteBackgroundDecorationView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public final class WhiteBackgroundDecorationView: UICollectionReusableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.systemWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
