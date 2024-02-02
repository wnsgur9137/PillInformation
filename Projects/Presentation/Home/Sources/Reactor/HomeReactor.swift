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

public protocol HomeReactorAction {
    
}

public protocol HomeReactorMutation {
    
}

public protocol HomeReactorState {
    
}

public protocol HomeReactor: HomeReactorAction, HomeReactorMutation, HomeReactorState {
    
}

public final class DefaultHomeReactor: Reactor, HomeReactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
}

public final class HomeReactorMock: HomeReactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
}
