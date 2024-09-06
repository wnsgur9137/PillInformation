//
//  LocalizationSettingReactor.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public enum LocalizationSettingItem: Int, CaseIterable {
    case korean
    case english
    
    func title() -> String {
        switch self {
        case .korean: return "한국어"
        case .english: return "english"
        }
    }
}

public final class LocalizationSettingReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case didSelectRow(IndexPath)
    }
    
    public enum Mutation {
        case loadLocalize
        case showBottomAlert(String?)
    }
    
    public struct State {
        var currentLocalizationSettingItem: LocalizationSettingItem?
        @Pulse var bottomAlertTitle: String?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let checkedLocalization: LocalizationSettingItem = .korean
    
    public init() {
        
    }
    
    private func didSelectRow(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let item = LocalizationSettingItem(rawValue: indexPath.row) else { return .just(.showBottomAlert(nil)) }
        let title = Constants.MyPage.askCheckLocalization // TODO: -
        return .just(.showBottomAlert(item.title()))
    }
}

// MARK: - Reactor
extension LocalizationSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.loadLocalize)
        case let .didSelectRow(indexPath):
            return didSelectRow(indexPath)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadLocalize:
            state.currentLocalizationSettingItem = .korean
        case let .showBottomAlert(title):
            state.bottomAlertTitle = title
        }
        return state
    }
}

// MARK: - Localize DataSource
extension LocalizationSettingReactor: LocalizationSettingDataSource {
    func numberOfRows(in section: Int) -> Int {
        return LocalizationSettingItem.allCases.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> (title: String, isChecked: Bool)? {
        guard let item = LocalizationSettingItem(rawValue: indexPath.row) else { return nil }
        return (title: item.title(), isChecked: false)
    }
}
