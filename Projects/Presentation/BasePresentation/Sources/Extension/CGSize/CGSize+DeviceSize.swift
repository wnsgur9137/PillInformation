//
//  CGSize+DeviceSize.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension CGSize {
    public static var deviceSize: CGSize = {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return CGSize() }
        return scene.screen.bounds.size
    }()
}
