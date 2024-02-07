//
//  HomeReactor.swift
//  Home
//
//  Created by JunHyeok Lee on 2/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

public final class HomeReactor: Reactor {
    public enum Action {
        case didTapTestButton
    }
    
    public enum Mutation {
        case didTappedTestButton
    }
    
    public struct State {
        var isLoading: Bool = false
    }
    
    public var initialState = State()
}

extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapTestButton:
            return Observable.just(.didTappedTestButton)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .didTappedTestButton:
            state.isLoading = true
        }
        return state
    }
}
