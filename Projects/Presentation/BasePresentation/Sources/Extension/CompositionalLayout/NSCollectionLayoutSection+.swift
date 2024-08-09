//
//  NSCollectionLayoutSection+.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension NSCollectionLayoutSection {
    public func ignoreInset(_ bool: Bool) {
        if #available(iOS 16.0, *) {
            supplementaryContentInsetsReference = bool ? .none : .automatic
        } else {
            supplementariesFollowContentInsets = !bool
        }
    }
}
