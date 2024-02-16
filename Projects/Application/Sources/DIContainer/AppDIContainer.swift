//
//  AppDIContainer.swift
//  Application
//
//  Created by JunHyeok Lee on 1/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let test = appConfiguration.apiBaseURL
        return MainSceneDIContainer()
    }
}
