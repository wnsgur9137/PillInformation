//
//  OnboardReactor.swift
//  OnboardingPresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct OnboardFlowAction {
    let popViewController: (Bool) -> Void
    let showMainScene: () -> Void
    
    public init(popViewController: @escaping (Bool) -> Void,
                showMainScene: @escaping () -> Void) {
        self.popViewController = popViewController
        self.showMainScene = showMainScene
    }
}

public final class OnboardReactor: Reactor {
    public enum Action {
        case didTapBackwardButton
        case didTapConfimButton
    }
    
    public enum Mutation {
        case popViewController
        case showMainScene
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let userUseCase: UserUseCase
    private let flowAction: OnboardFlowAction
    private let disposeBag = DisposeBag()
    
    public init(with userUseCase: UserUseCase,
                flowAction: OnboardFlowAction) {
        self.userUseCase = userUseCase
        self.flowAction = flowAction
    }
    
    private func updateIsShownOnboarding() ->Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.userUseCase.updateIsShownOnboarding(true)
                .subscribe(onSuccess: { bool in
                    return observable.onNext(.showMainScene)
                }, onFailure: { error in
                    print("Error: \(error)")
                    return observable.onNext(.showMainScene)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension OnboardReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackwardButton:
            return .just(.popViewController)
        case .didTapConfimButton:
            return updateIsShownOnboarding()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .popViewController:
            popViewController()
        case .showMainScene:
            showMainScene()
        }
        return state
    }
}

// MARK: - Flow action
extension OnboardReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func showMainScene() {
        flowAction.showMainScene()
    }
}
