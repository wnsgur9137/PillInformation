//
//  String+Localization.swift
//  BasePresentation
//
//  Created by JunHyoek Lee on 8/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
