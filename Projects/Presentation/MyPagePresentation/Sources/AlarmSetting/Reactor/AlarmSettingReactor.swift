//
//  AlarmSettingReactor.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct AlarmSettingFlowAction {
    
    public init() {
        
    }
}

public final class AlarmSettingReactor: Reactor {
    typealias ErrorContents = (title: String, message: String?)
    
    public enum AlarmSettingError: Error {
        case load
        case change
    }
    
    public enum Action {
        case viewDidLoad
        case didSelectRow(IndexPath)
    }
    
    public enum Mutation {
        case error(AlarmSettingError)
        case reloadData
    }
    
    public struct State {
        var reloadData: Void?
        @Pulse var errorAlertContents: ErrorContents?
    }
    
    private enum AlarmType: Int {
        case day
        case night
    }
    
    public var initialState = State()
    private let alarmSettingUseCase: AlarmSettingUseCase
    private let flowAction: AlarmSettingFlowAction
    private let disposeBag = DisposeBag()
    
    private var userAlarmSetting: AlarmSettingModel?
    
    public init(with alarmSettingUseCase: AlarmSettingUseCase,
                flowAction: AlarmSettingFlowAction) {
        self.alarmSettingUseCase = alarmSettingUseCase
        self.flowAction = flowAction
        
        loadUserAlarmSetting()
    }
    
    private func loadUserAlarmSetting() {
        self.alarmSettingUseCase.fetchAlarmSetting()
            .subscribe(onSuccess: { [weak self] userAlarmSetting in
                self?.userAlarmSetting = userAlarmSetting
            }, onFailure: { [weak self] error in
                self?.userAlarmSetting = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func changeAlarm(at indexPath: IndexPath) -> Observable<Mutation> {
        
        guard var userAlarmSetting = userAlarmSetting else {
            return .just(.error(.change))
        }
        
        switch indexPath.row {
        case AlarmType.day.rawValue:
            userAlarmSetting.isAgreeDaytimeNoti = !userAlarmSetting.isAgreeDaytimeNoti
            
        case AlarmType.night.rawValue:
            userAlarmSetting.isAgreeNighttimeNoti = !userAlarmSetting.isAgreeNighttimeNoti
            
        default: return .just(.error(.change))
        }
        
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.alarmSettingUseCase.updateAlarmSetting(userAlarmSetting)
                .subscribe(onSuccess: { [weak self] userAlarmSetting in
                    self?.userAlarmSetting = userAlarmSetting
                    return observable.onNext(.reloadData)
                }, onFailure: { error in
                    return observable.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func makeErrorAlertContents(_ error: AlarmSettingError) -> ErrorContents {
        switch error {
        case .load:
            return (
                title: Constants.AlarmSetting.loadErrorTitle,
                message: Constants.AlarmSetting.tryAgain
            )
            
        case .change:
            return (
                title: Constants.AlarmSetting.changeErrorTitle,
                message: Constants.AlarmSetting.tryAgain
            )
        }
    }
}

// MARK: - React
extension AlarmSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            guard let userAlarmSetting = userAlarmSetting else {
                return .just(.error(.load))
            }
            return .just(.reloadData)
            
        case let .didSelectRow(indexPath):
            return changeAlarm(at: indexPath)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadData:
            state.reloadData = Void()
            
        case let .error(error):
            state.errorAlertContents = makeErrorAlertContents(error)
        }
        return state
    }
}

// MARK: - Flow action
extension AlarmSettingReactor {
    
}

// MARK: - AlarmSettingAdapter DataSource
extension AlarmSettingReactor: AlarmSettingAdapterDataSource {
    public func numberOfRows(in section: Int) -> Int {
        return 2
    }
    
    public func cellForRow(at indexPath: IndexPath) -> AlarmSettingCellInfo {
        if indexPath.row == 0 {
            return .init(title: "낮", content: "동의하라", isAgree: true)
        } else {
            return .init(title: "밤", content: "동의하람마", isAgree: false)
        }
    }
}
