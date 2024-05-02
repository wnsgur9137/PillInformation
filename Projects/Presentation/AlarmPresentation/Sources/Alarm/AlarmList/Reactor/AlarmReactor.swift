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
    let showAlarmDetailViewController: (AlarmModel?) -> Void
    
    public init(showAlarmDetailViewController: @escaping (AlarmModel?) -> Void) {
        self.showAlarmDetailViewController = showAlarmDetailViewController
    }
}

public final class AlarmReactor: Reactor {
    public enum Action {
        case viewWillAppear
    }
    
    public enum Mutation {
        case loadAlarm
        case error(Error?)
    }
    
    public struct State {
        @Pulse var alarmCellCount: Int = 0
        @Pulse var isError: Error?
    }
    
    public var initialState = State()
    private let useCase: AlarmUseCase
    private let flowAction: AlarmFlowAction
    private let disposeBag = DisposeBag()
    private var alarmData: [AlarmModel] = []
    
    public init(with useCase: AlarmUseCase,
                flowAction: AlarmFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadAlarm() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeAll()
                .subscribe(onSuccess: { [weak self] alarms in
                    self?.alarmData = alarms
                    observable.onNext(.loadAlarm)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func update(alarm: AlarmModel) {
        self.useCase.update(alarm)
            .subscribe(onSuccess: { _ in })
            .disposed(by: disposeBag)
    }
    
    private func delete(alarm: AlarmModel?) {
        guard let alarm = alarm else { return }
        self.useCase.delete(alarm.id)
            .subscribe(onSuccess: { _ in })
            .disposed(by: disposeBag)
    }
}

// MARK: - React
extension AlarmReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return loadAlarm()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadAlarm:
            state.alarmCellCount = alarmData.count
            
        case let .error(error):
            state.isError = error
        }
        return state
    }
}

extension AlarmReactor {
    func didSelectAddButton() {
        showAlarmDetailViewController()
    }
    
    func didSelectToggleButton(at indexPath: IndexPath) {
        var alarm = alarmData[indexPath.row]
        alarm.isActive = !alarm.isActive
        update(alarm: alarm)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        showAlarmDetailViewController(alarmData[indexPath.row])
    }
    
    func delete(indexPath: IndexPath) {
        let alarm = alarmData[indexPath.row]
        delete(alarm: alarm)
        alarmData.remove(at: indexPath.row)
    }
}

// MARK: - Flow Action
extension AlarmReactor {
    private func showAlarmDetailViewController(_ alarmData: AlarmModel? = nil) {
        flowAction.showAlarmDetailViewController(alarmData)
    }
}

// MARK: - AlarmAdapter DataSource
extension AlarmReactor: AlarmAdapterDataSource {
    func numberOfRowsIn(section: Int) -> Int {
        return alarmData.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> AlarmModel {
        return alarmData[indexPath.row]
    }
}
