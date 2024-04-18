//
//  AlarmReactor.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct AlarmFlowAction {
    
    public init() {
        
    }
}

public final class AlarmReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public let flowAction: AlarmFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: AlarmFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension AlarmReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        }
        return state
    }
}

// MARK: - Flow Action

// MARK: - AlarmAdapter DataSource
extension AlarmReactor: AlarmAdapterDataSource {
    func numberOfRowsIn(section: Int) -> Int {
        return 5
    }
    
    func cellForRow(at indexPath: IndexPath) {
        
    }
}
