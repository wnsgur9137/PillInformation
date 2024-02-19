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
        case loadNotices
        case testData([String])
    }
    
    public struct State {
        var isLoading: Bool = true
        var isLoadedNotices: Bool = false
        var testData: [String]?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let homeUseCase: HomeUseCase
    
    private var notices: [Notice] = []
    
    public init(with useCase: HomeUseCase) {
        self.homeUseCase = useCase
    }
    
    private func loadNotice() -> Observable<[Notice]> {
        return homeUseCase.executeNotice()
            .asObservable()
    }
    private func loadTest() -> Observable<[String]> {
        return homeUseCase.executeTestData()
            .asObservable()
    }
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotice()
                .flatMap { [weak self] notice -> Observable<Mutation> in
                    self?.notices = notice
                    return .just(.loadNotices)
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
        case .loadNotices:
            state.isLoadedNotices = true
            
        case let .testData(testData):
            state.testData = testData
        }
        return state
    }
}

// MARK: - HomeAdapter DataSource
extension HomeReactor: HomeAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        return notices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> HomeDomain.Notice? {
        return notices[indexPath.row]
    }
    
    
}
