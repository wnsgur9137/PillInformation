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
    }
    
    public enum Mutation {
        case loadNotices
    }
    
    public struct State {
        var isLoading: Bool = true
        var isLoadedNotices: Bool = false
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
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadNotices:
            state.isLoadedNotices = true
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
