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

import BasePresentation
import NotificationInfra

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
    private var alarms: [AlarmModel] = []
    
    public init(with useCase: AlarmUseCase,
                flowAction: AlarmFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
        self.useCase.deleteAll()
            .subscribe(onSuccess: { _ in })
            .disposed(by: self.disposeBag)
    }
    
    private func addNotification(alarm: AlarmModel, index: Int) {
        let days = [alarm.week.sunday, alarm.week.monday, alarm.week.tuesday, alarm.week.wednesday, alarm.week.thursday, alarm.week.friday, alarm.week.saturday]
        
        for (index, day) in days.enumerated() {
            guard day == true else { return }
            let weekday = index + 1
            let id = NotificationIdentifier.alarm(id: alarm.id, day: weekday)
            var targetDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: alarm.alarmTime)
            targetDate.weekday = weekday
            NotificationService.addTriggerNotification(id: id,
                                                       title: Constants.AlarmViewController.notificationTitle,
                                                       body: alarm.title ?? "",
                                                       date: targetDate,
                                                       repeats: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Error: \(error)")
                }
                self.deleteNotification(id: alarm.id)
                DispatchQueue.main.async {
                    self.useCase.update(alarm)
                        .subscribe(onSuccess: { [weak self] alarm in
                            self?.alarms[index] = alarm
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
    }
    
    private func deleteNotification(id: Int) {
        var ids: [String] = []
        for index in 1...7 {
            ids.append(NotificationIdentifier.alarm(id: id, day: index))
        }
        ids.forEach { id in
            NotificationService.deletePendingNotification(id: id)
            NotificationService.deleteDeliveredNotification(id: id)
        }
    }
    
    private func loadAlarm() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeAll()
                .subscribe(onSuccess: { [weak self] alarms in
                    self?.alarms = alarms
                    observable.onNext(.loadAlarm)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func update(alarm: AlarmModel, index: Int) {
        self.useCase.update(alarm)
            .subscribe(onSuccess: { [weak self] alarm in
                self?.alarms[index] = alarm
            })
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
            state.alarmCellCount = alarms.count
            
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
        var alarm = alarms[indexPath.row]
        alarm.isActive = !alarm.isActive
        alarm.isActive ? addNotification(alarm: alarm, index: indexPath.row) : deleteNotification(id: alarm.id)
        update(alarm: alarm, index: indexPath.row)
    }
    
    func didSelectWeekButton(at indexPath: IndexPath, button: AlarmAdapter.WeekButton) {
        var alarm = alarms[indexPath.row]
        switch button {
        case .sunday: alarm.week.sunday = !alarm.week.sunday
        case .monday: alarm.week.monday = !alarm.week.monday
        case .tuesday: alarm.week.tuesday = !alarm.week.tuesday
        case .wednesday: alarm.week.wednesday = !alarm.week.wednesday
        case .thursday: alarm.week.thursday = !alarm.week.thursday
        case .friday: alarm.week.friday = !alarm.week.friday
        case .saturday: alarm.week.saturday = !alarm.week.saturday
        }
        update(alarm: alarm, index: indexPath.row)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        showAlarmDetailViewController(alarms[indexPath.row])
    }
    
    func delete(indexPath: IndexPath) {
        let alarm = alarms[indexPath.row]
        delete(alarm: alarm)
        self.alarms.remove(at: indexPath.row)
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
    func numberOfRows(in section: Int) -> Int {
        return alarms.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> AlarmModel {
        return alarms[indexPath.row]
    }
}
