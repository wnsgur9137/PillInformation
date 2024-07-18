//
//  SplashDIContainer.swift
//  Splash
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import BaseData
import SplashData
import SplashDomain
import SplashPresentation

public final class SplashDIContainer {
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

// MARK: - SplashCoordinator Dependencies
extension SplashDIContainer: SplashCoordinatorDependencies {
    public func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(networkManager: dependencies.networkManager)
    }
    
    public func makeUserSplashRepository() -> UserSplashRepository {
        return DefaultUserSplashRepository(networkManager: dependencies.networkManager, userRepository: makeUserRepository())
    }
    
    public func makeUserUseCase() -> UserUseCase {
        return DefaultUserUseCase(with: makeUserSplashRepository())
    }
    
    public func makeSplashReactor(flowAction: SplashFlowAction) -> SplashReactor {
        return SplashReactor(with: makeUserUseCase(), flowAction: flowAction)
    }
    
    public func makeSplashViewController(flowAction: SplashFlowAction) -> SplashViewController {
        return SplashViewController.create(with: makeSplashReactor(flowAction: flowAction))
    }
}
