//
//  TimerReactor.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import ReactiveLibraries

public struct TimerFlowAction {
    let showTimerDetailViewController: () -> Void
    
    public init(showTimerDetailViewController: @escaping () -> Void) {
        self.showTimerDetailViewController = showTimerDetailViewController
    }
}

public final class TimerReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    public enum Mutation {
        case loadTimerData
        case loadError
        case asdf
    }
    
    public struct State {
        @Pulse var timerCellCount: Int = 0
        @Pulse var isError: RevisionedData<Void?> = .init(nil)
    }
    
    public var initialState = State()
    public let flowAction: TimerFlowAction
    private let useCase: TimerUseCase
    private let disposeBag = DisposeBag()
    
    private var operationTimerData: [TimerModel] = []
    private var nonOperationTimerData: [TimerModel] = []
    
    public init(with useCase: TimerUseCase,
                flowAction: TimerFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadTimerData() -> Observable<Mutation> {
        return .create() { observable in
            self.useCase.executeAll()
                .subscribe(onSuccess: { [weak self] timerModels in
                    self?.operationTimerData = timerModels.filter { $0.isStarted }
                    self?.nonOperationTimerData = timerModels.filter { !$0.isStarted }
                    observable.onNext(.loadTimerData)
                }, onFailure: { error in
                    observable.onNext(.loadError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension TimerReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: // MARK: - Test Code
            self.useCase.deleteAll().subscribe(onSuccess: {
                print("Success Delete All")
            },onFailure: { error in
                print("Failed Delete All")
            })
            .disposed(by: disposeBag)
            return .just(.asdf)
        case .viewWillAppear:
            return loadTimerData()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadTimerData:
            state.timerCellCount = operationTimerData.count + nonOperationTimerData.count
        case .loadError:
            state.isError = state.isError.update(Void())
        case .asdf:
            break
        }
        return state
    }
}

extension TimerReactor {
    func didSelectAddButton() {
        showTimerDetailViewController()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        showTimerDetailViewController()
    }
    
    func delete(indexPath: IndexPath) {
        if indexPath.section == 0 {
            operationTimerData.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            nonOperationTimerData.remove(at: indexPath.row)
        }
    }
}

// MARK: - TimerAdapterDataSource
extension TimerReactor: TimerAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        switch section {
        case 0: return operationTimerData.count
        case 1: return nonOperationTimerData.count
        default: return 0
        }
    }
    
    public func cellForRow(at indexPath: IndexPath) {
        
    }
}

// MARK: - FlowAction
extension TimerReactor {
    func showTimerDetailViewController() {
        flowAction.showTimerDetailViewController()
    }
}