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
    let showTimerDetailViewController: (TimerModel?) -> Void
    
    public init(showTimerDetailViewController: @escaping (TimerModel?) -> Void) {
        self.showTimerDetailViewController = showTimerDetailViewController
    }
}

public final class TimerReactor: Reactor {
    public enum Action {
        case viewWillAppear
    }
    
    public enum Mutation {
        case loadTimerData
        case loadError
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
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeAll()
                .subscribe(onSuccess: { [weak self] timerModels in
                    self?.operationTimerData.removeAll()
                    self?.nonOperationTimerData.removeAll()
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
    
    private func update(timerModel: TimerModel) {
        self.useCase.update(timerModel)
            .subscribe(onSuccess: { _ in })
            .disposed(by: disposeBag)
    }
    
    private func delete(timerModel: TimerModel?) {
        guard let timerModel = timerModel else { return }
        self.useCase.delete(timerModel.id)
            .subscribe(onSuccess: { _ in })
            .disposed(by: disposeBag)
    }
}

// MARK: - React
extension TimerReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        }
        return state
    }
}

extension TimerReactor {
    func didSelectAddButton() {
        showTimerDetailViewController()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        var timerModel: TimerModel?
        if indexPath.section == 0 {
            timerModel = operationTimerData[indexPath.row]
        } else if indexPath.section == 1 {
            timerModel = nonOperationTimerData[indexPath.row]
        }
        showTimerDetailViewController(timerModel: timerModel)
    }
    
    func delete(indexPath: IndexPath) {
        var timerModel: TimerModel?
        if indexPath.section == 0 {
            timerModel = operationTimerData[indexPath.row]
            operationTimerData.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            timerModel = nonOperationTimerData[indexPath.row]
            nonOperationTimerData.remove(at: indexPath.row)
        }
        delete(timerModel: timerModel)
    }
}

// MARK: - TimerAdapterDataSource
extension TimerReactor: TimerAdapterDataSource {
    public func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return operationTimerData.count
        case 1: return nonOperationTimerData.count
        default: return 0
        }
    }
    
    public func cellForRow(at indexPath: IndexPath) -> TimerModel? {
        switch indexPath.section {
        case 0: return operationTimerData[indexPath.row]
        case 1: return nonOperationTimerData[indexPath.row]
        default: return nil
        }
    }
    
    public func update(_ timerModel: TimerModel) {
        self.update(timerModel: timerModel)
    }
}

// MARK: - FlowAction
extension TimerReactor {
    func showTimerDetailViewController(timerModel: TimerModel? = nil) {
        flowAction.showTimerDetailViewController(timerModel)
    }
}
