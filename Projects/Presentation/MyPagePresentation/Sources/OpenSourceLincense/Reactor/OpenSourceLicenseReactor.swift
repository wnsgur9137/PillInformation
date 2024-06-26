//
//  OpenSourceLicenseReactor.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct OpenSourceLicenseFlowAction {
    
    public init() {
        
    }
}

public final class OpenSourceLicenseReactor: Reactor {
    public enum Action {
        case test
    }
    
    public enum Mutation {
        case test
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: OpenSourceLicenseFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: OpenSourceLicenseFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - Reactor
extension OpenSourceLicenseReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        default: return .just(.test)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        default: break
        }
        return state
    }
}

// MARK: - FlowAction
extension OpenSourceLicenseReactor {
    
}
