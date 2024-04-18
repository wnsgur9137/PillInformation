//
//  BookmarkReactor.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct BookmarkFlowAction {
    public init() {
        
    }
}

public final class BookmarkReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: BookmarkFlowAction
    
    public init(flowAction: BookmarkFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension BookmarkReactor {
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

// MARK: - BookmarkAdapter DataSource
extension BookmarkReactor: BookmarkAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        return 0
    }
    
    public func cellForRow(at indexPath: IndexPath) {
        
    }
}

// MARK: - Flow Action
extension BookmarkReactor {
    
}
