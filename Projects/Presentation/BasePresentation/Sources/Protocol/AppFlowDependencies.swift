//
//  AppFlowDependencies.swift
//  BasePresentation
//
//  Created by JunHyoek Lee on 9/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public protocol AppFlowDependencies {
    func showMain()
    func showOnboarding(isNeedSignin: Bool)
    func showSplash()
}
