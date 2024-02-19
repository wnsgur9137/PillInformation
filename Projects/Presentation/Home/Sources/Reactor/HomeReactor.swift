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
import HomeDomain

public final class HomeReactor: Reactor {
    public enum Action {
        case loadNotices
        case loadTestData
    }
    
    public enum Mutation {
        case notices([Notice])
        case testData([String])
    }
    
    public struct State {
        var isLoading: Bool = true
        var notices: [Notice]?
        var testData: [String]?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let homeUseCase: HomeUseCase
    
    public init(with useCase: HomeUseCase) {
        self.homeUseCase = useCase
    }
}

extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotice()
                .flatMap { notices -> Observable<Mutation> in
                    return .just(.notices(notices))
                }
            
        case .loadTestData:
            return loadTest()
                .flatMap { testData -> Observable<Mutation> in
                    return .just(.testData(testData))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .notices(notices):
            state.notices = notices
            
        case let .testData(testData):
            state.testData = testData
        }
        return state
    }
}

extension HomeReactor {
    private func loadNotice() -> Observable<[Notice]> {
        return homeUseCase.executeNotice()
            .asObservable()
    }
    private func loadTest() -> Observable<[String]> {
        return homeUseCase.executeTestData()
            .asObservable()
    }
}
