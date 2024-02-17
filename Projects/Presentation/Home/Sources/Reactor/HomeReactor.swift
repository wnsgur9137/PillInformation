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
        case willAppear
        case didTapTestButton
    }
    
    public enum Mutation {
        case willAppear(String)
        case didTappedTestButton
    }
    
    public struct State {
        var isLoading: Bool = true
        var notices: String?
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
        case .willAppear:
            return loadNotice()
                .flatMap { notice -> Observable<Mutation> in
                    return .just(.willAppear(notice))
                }
            
        case .didTapTestButton:
            return Observable.just(.didTappedTestButton)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .willAppear(notices):
            state.notices = notices
            state.isLoading = false
        case .didTappedTestButton:
            break
        }
        return state
    }
}

extension HomeReactor {
    private func loadNotice() -> Observable<String> {
        return homeUseCase.getNotice()
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .asObservable()
    }
}
