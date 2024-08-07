//
//  HealthReactor.swift
//  HealthPresentation
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import HealthKit

import BasePresentation

public struct HealthFlowAction {
    
    public init() {
        
    }
}

public final class HealthReactor: Reactor {
    public enum Action {
        case didTapAuthButton
    }
    
    public enum Mutation {
        case requestHealthKitAuth(Bool)
    }
    
    public struct State {
        var isHealthAuthenticationRequired: Bool = false
    }
    
    public var initialState = State()
    public let flowAction: HealthFlowAction
    private let disposeBag = DisposeBag()
    private let healthStore = HKHealthStore()
    
    public init(flowAction: HealthFlowAction) {
        self.flowAction = flowAction
    }
    
    private func requestHealthAuthorization() -> Observable<Mutation> {
        guard HKHealthStore.isHealthDataAvailable(),
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
              let allergyRecord = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
              let conditionRecord = HKObjectType.clinicalType(forIdentifier: .conditionRecord),
              let immunizationRecord = HKObjectType.clinicalType(forIdentifier: .immunizationRecord),
              let medicationRecord = HKObjectType.clinicalType(forIdentifier: .medicationRecord) else {
            return .just(.requestHealthKitAuth(false))
        }
        
        let share: Set<HKSampleType> = []
        let read: Set<HKObjectType> = []
        
        return .create { observable in
            self.healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
                print("success: \(success)")
            }
            
            return Disposables.create()
        }
    }
}

// MARK: - Reactor
extension HealthReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAuthButton:
            return requestHealthAuthorization()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .requestHealthKitAuth(isAuth):
            state.isHealthAuthenticationRequired = isAuth
        }
        return state
    }
}

// MARK: - Flow Action
extension HealthReactor {
    
}
