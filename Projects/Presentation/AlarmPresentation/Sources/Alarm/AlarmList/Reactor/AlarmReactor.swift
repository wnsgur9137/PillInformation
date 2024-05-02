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
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public let flowAction: AlarmFlowAction
    private let disposeBag = DisposeBag()
    private var alarmData: [AlarmModel] = []
    
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

extension AlarmReactor {
    func didSelectAddButton() {
        showAlarmDetailViewController()
    }
    
    func didSelectToggleButton(at indexPath: IndexPath) {
        
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        showAlarmDetailViewController()
//        showAlarmDetailViewController(alarmData[indexPath.row])
    }
    
    func delete(indexPath: IndexPath) {
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
        return 5
    }
    
    func cellForRow(at indexPath: IndexPath) {
        
    }
}
