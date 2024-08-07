//
//  LottieAnimationView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Lottie

public enum LottieAnimationType: String {
    case loading = "loadingAnimation"
    case emptyResult = "emptyAnimation"
    case pill = "pillAnimation"
}

extension LottieAnimationView {
    public convenience init(_ type: LottieAnimationType) {
        self.init(name: type.rawValue)
    }
}
