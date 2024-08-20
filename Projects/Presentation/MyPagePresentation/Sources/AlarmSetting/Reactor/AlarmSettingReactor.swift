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
    let popViewController: (Bool) -> Void
    public init(popViewController: @escaping ((Bool)->Void)) {
        self.popViewController = popViewController
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
        case popViewController
    }
    
    public enum Mutation {
        case error(AlarmSettingError)
        case reloadData
        case popViewController
    }
    
    public struct State {
        var reloadData: Void?
        @Pulse var errorAlertContents: (contents: ErrorContents, needDismiss: Bool)?
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
    }
    
    private func loadUserAlarmSetting() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.alarmSettingUseCase.fetchAlarmSetting()
                .subscribe(onSuccess: { [weak self] userAlarmSetting in
                    self?.userAlarmSetting = userAlarmSetting
                    observable.onNext(.reloadData)
                }, onFailure: { [weak self] error in
                    self?.userAlarmSetting = nil
                    observable.onNext(.error(.load))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        }
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
                    return observable.onNext(.error(.change))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func makeErrorAlertContents(_ error: AlarmSettingError) -> (contents: ErrorContents, needDismiss: Bool) {
        switch error {
        case .load:
            return ((
                title: Constants.MyPage.loadErrorTitle,
                message: Constants.MyPage.tryAgain
            ), needDismiss: true)
            
        case .change:
            return ((
                title: Constants.MyPage.changeErrorTitle,
                message: Constants.MyPage.tryAgain
            ), needDismiss: false)
        }
    }
}

// MARK: - React
extension AlarmSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return loadUserAlarmSetting()
            
        case let .didSelectRow(indexPath):
            return changeAlarm(at: indexPath)
            
        case .popViewController:
            return .just(.popViewController)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadData:
            state.reloadData = Void()
            
        case let .error(error):
            state.errorAlertContents = makeErrorAlertContents(error)
            
        case .popViewController:
            popViewController()
        }
        return state
    }
}

// MARK: - Flow action
extension AlarmSettingReactor {
    private func popViewController(_ animated: Bool = true) {
        flowAction.popViewController(animated)
    }
}

// MARK: - AlarmSettingAdapter DataSource
extension AlarmSettingReactor: AlarmSettingAdapterDataSource {
    public func numberOfRows(in section: Int) -> Int {
        return 2
    }
    
    public func cellForRow(at indexPath: IndexPath) -> AlarmSettingCellInfo {
        if indexPath.row == 0 {
            return .init(
                title: Constants.MyPage.dayNotiTitle,
                content: Constants.MyPage.dayNotiDescription,
                isAgree: userAlarmSetting?.isAgreeDaytimeNoti ?? false
            )
        } else {
            return .init(
                title: Constants.MyPage.nightNotiTitle,
                content: Constants.MyPage.nightNotiDescription,
                isAgree: userAlarmSetting?.isAgreeNighttimeNoti ?? false
            )
        }
    }
}
