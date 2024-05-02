//
//  AlarmDetailReactor.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct AlarmDetailFlowAction {
    
    public init() {
        
    }
}

public final class AlarmDetailReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case didTapSundayButton
        case didTapMondayButton
        case didTapTuesdayButton
        case didTapWednesdayButton
        case didTapThurdayButton
        case didTapFridayButton
        case didTapSaturdayButton
    }
    
    public enum Mutation {
        case checkData
        case didTapWeekButton(WeekModel?)
    }
    
    public struct State {
        var alarmData: AlarmModel?
        var week: WeekModel?
    }
    
    public var initialState = State()
    private let flowAction: AlarmDetailFlowAction
    private let disposeBag = DisposeBag()
    private var alarmData: AlarmModel?
    private var week: WeekModel = WeekModel()
    
    public init(alarmModel: AlarmModel? = nil,
                flowAction: AlarmDetailFlowAction) {
        self.alarmData = alarmModel
        self.flowAction = flowAction
        
        if let alarmData = self.alarmData {
            self.week = alarmData.week
        }
    }
}

// MARK: - React
extension AlarmDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.checkData)
            
        case .didTapSundayButton: 
            week.sunday = !week.sunday
            return .just(.didTapWeekButton(week))
            
        case .didTapMondayButton:
            week.monday = !week.monday
            return .just(.didTapWeekButton(week))
            
        case .didTapTuesdayButton:
            week.tuesday = !week.tuesday
            return .just(.didTapWeekButton(week))
            
        case .didTapWednesdayButton:
            week.wednesday = !week.wednesday
            return .just(.didTapWeekButton(week))
            
        case .didTapThurdayButton:
            week.thursday = !week.thursday
            return .just(.didTapWeekButton(week))
            
        case .didTapFridayButton:
            week.friday = !week.friday
            return .just(.didTapWeekButton(week))
            
        case .didTapSaturdayButton:
            week.saturday = !week.saturday
            return .just(.didTapWeekButton(week))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .checkData:
            state.alarmData = alarmData
            
        case let .didTapWeekButton(week):
            state.week = week
        }
        return state
    }
}

extension AlarmDetailReactor {
    
}

// MARK: - FlowAction
extension AlarmDetailReactor {
    
}
