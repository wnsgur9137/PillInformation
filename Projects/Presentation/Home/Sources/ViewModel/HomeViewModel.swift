//
//  HomeViewModel.swift
//  Home
//
//  Created by JunHyeok Lee on 2/1/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct HomeViewModelAction {
    
}

public protocol HomeViewModelInput {
    
}

public protocol HomeViewModelOutput {
    
}

public protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

public final class DefaultHomeViewModel: HomeViewModel {
    
    private let action: HomeViewModelAction
    
    public init(action: HomeViewModelAction) {
        self.action = action
    }
}

extension DefaultHomeViewModel {
    
}
