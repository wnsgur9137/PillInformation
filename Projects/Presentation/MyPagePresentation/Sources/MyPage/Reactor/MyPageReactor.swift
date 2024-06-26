//
//  MyPageReactor.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct MyPageFlowAction {
    
    public init() {
        
    }
}

public final class MyPageReactor: Reactor {
    public enum MyPageAlert {
        case warning
        case signout
        case withdrawal
    }
    
    public enum Action {
        case didSelectRow(IndexPath)
    }
    
    public enum Mutation {
        case showAlarmViewController
        case showAppPolicyViewController
        case showPrivacyPolicyViewController
        case showOpensourceLicenseViewController
        case signout
        case withdrawal
        case showAlert(MyPageAlert)
    }
    
    public struct State {
        @Pulse var warningAlert: (title: String, message: String?)?
        @Pulse var signoutAlert: Void?
        @Pulse var withdrawalAlert: Void?
    }
    
    private enum MyPageSection: Int {
        case appSetting = 0
        case appInfo = 1
        case accountOption = 2
    }
    
    private enum Policy {
        case app
        case privacy
    }
    
    public var initialState = State()
    private let flowAction: MyPageFlowAction
    private let disposeBag = DisposeBag()
    
    private var appSettingTitles: [String] = [
        Constants.MyPage.appAlarmSetting,
    ]
    
    private var appInfoTitles: [String] = [
        Constants.MyPage.appPolicy,
        Constants.MyPage.privacyPolicy,
        Constants.MyPage.opensourceLicense
    ]
    
    private var accountOptionTitles: [String] = [
        Constants.MyPage.signout,
        Constants.MyPage.withdrawal
    ]
    
    public init(flowAction: MyPageFlowAction) {
        self.flowAction = flowAction
    }
    
    private func didSelectRow(_ indexPath: IndexPath) -> Observable<Mutation>? {
        switch indexPath.section {
        case MyPageSection.appSetting.rawValue:
            return .just(.showAlarmViewController)
            
        case MyPageSection.appInfo.rawValue: break
            switch indexPath.row {
            case 0: return .just(.showAppPolicyViewController)
            case 1: return .just(.showPrivacyPolicyViewController)
            case 2: return .just(.showOpensourceLicenseViewController)
            default: break
            }
            
        case MyPageSection.accountOption.rawValue:
            switch indexPath.row {
            case 0: return .just(.showAlert(.signout))
            case 1: return .just(.showAlert(.withdrawal))
            default: break
            }
            
        default: break
        }
        return nil
    }
    
    private func signout() {
        
    }
    
    private func withdrawal() {
        
    }
}

// MARK: - Reactor
extension MyPageReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectRow(indexPath):
            return didSelectRow(indexPath) ?? .just(.showAlert(.warning))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .showAlarmViewController:
            showAlarmViewController()
            
        case .showAppPolicyViewController:
            showPolicyViewController(.app)
            
        case .showPrivacyPolicyViewController:
            showPolicyViewController(.privacy)
            
        case .showOpensourceLicenseViewController:
            showOpensourceLicenseViewController()
            
        case .signout:
            signout()
            
        case .withdrawal:
            withdrawal()
            
        case let .showAlert(myPageAlert):
            switch myPageAlert {
            case .signout: break
            case .withdrawal: break
            case .warning: break
            }
        }
        return state
    }
}

// MARK: - Flow Action
extension MyPageReactor {
    private func showAlarmViewController() {
        
    }
    
    private func showPolicyViewController(_ policy: Policy) {
        switch policy {
        case .app: break
        case .privacy: break
        }
    }
    
    private func showOpensourceLicenseViewController() {
        
    }
    
    private func showOnboardingScene() {
        
    }
}

// MARK: - MyPageAdapter TableViewDataSource
extension MyPageReactor: MyPageAdapterDataSource {
    public func numberOfSections() -> Int {
        return 3
    }
    
    public func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return appSettingTitles.count
        case 1: return appInfoTitles.count
        case 2: return accountOptionTitles.count
        default: return 0
        }
    }
    
    public func cellForRow(at indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return appSettingTitles[indexPath.row]
        case 1: return appInfoTitles[indexPath.row]
        case 2: return accountOptionTitles[indexPath.row]
        default: return ""
        }
    }
    
    public func cellForRowTest(at indexPath: IndexPath) -> Observable<String> {
        switch indexPath.section {
        case 0: return .of(appSettingTitles[indexPath.row])
        case 1: return .of(appInfoTitles[indexPath.row])
        case 2: return .of(accountOptionTitles[indexPath.row])
        default: return .of("")
        }
    }
}
