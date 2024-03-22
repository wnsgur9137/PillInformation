//
//  AlarmDIContainer.swift
//  Alarm
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import AlarmData
import AlarmDomain
import AlarmPresentation

public final class AlarmDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - AlarmCoordinatorDependencies
extension AlarmDIContainer: AlarmCoordinatorDependencies {
    public func makeAlarmViewController() -> AlarmViewController {
        return AlarmViewController()
    }
}

