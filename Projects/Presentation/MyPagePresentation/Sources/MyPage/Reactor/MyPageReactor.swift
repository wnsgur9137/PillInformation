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

public enum PolicyType {
    case app
    case privacy
}

public struct MyPageFlowAction {
    let showAlarmSettingViewController: () -> Void
    let showPolicyViewController: (PolicyType) -> Void
    let showOpenSourceLicenseViewController: () -> Void
    let showOnboardingScene: () -> Void
    
    public init(showAlarmSettingViewController: @escaping(()->Void),
                showPolicyViewController: @escaping((PolicyType)->Void),
                showOpenSourceLicenseViewController: @escaping(()->Void),
                showOnboardingScene: @escaping(()->Void)) {
        self.showAlarmSettingViewController = showAlarmSettingViewController
        self.showPolicyViewController = showPolicyViewController
        self.showOpenSourceLicenseViewController = showOpenSourceLicenseViewController
        self.showOnboardingScene = showOnboardingScene
    }
}

public final class MyPageReactor: Reactor {
    public enum MyPageAlert {
        case warning
        case signout
        case withdrawal
        case signoutError
        case withdrawalError
    }
    
    public enum Action {
        case viewDidLoad
        case didSelectRow(IndexPath)
        case signOut
        case withdrawal
    }
    
    public enum Mutation {
        case reloadTableViewData
        case showAlarmViewController
        case showAppPolicyViewController
        case showPrivacyPolicyViewController
        case showOpensourceLicenseViewController
        case showOnboardingScene
        case showAlert(MyPageAlert)
    }
    
    public struct State {
        @Pulse var reloadTableViewData: Void?
        @Pulse var alert: MyPageAlert?
        @Pulse var dismiss: Bool?
    }
    
    private enum MyPageSection: Int {
        case appSetting = 0
        case appInfo = 1
        case accountOption = 2
    }
    
    public var initialState = State()
    private var isSigned: Bool = false
    private let userUseCase: UserUseCase
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
    
    public init(with useCase: UserUseCase,
                flowAction: MyPageFlowAction) {
        self.userUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func didSelectRow(_ indexPath: IndexPath) -> Observable<Mutation>? {
        switch indexPath.section {
        case MyPageSection.appSetting.rawValue:
            return .just(.showAlarmViewController)
            
        case MyPageSection.appInfo.rawValue:
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
    
    private func fetchUser() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.userUseCase.fetchFirstUserStorage()
                .subscribe(onSuccess: { [weak self] _ in
                    self?.isSigned = true
                    observable.onNext(.reloadTableViewData)
                }, onFailure: { [weak self] _ in
                    self?.isSigned = false
                    observable.onNext(.reloadTableViewData)
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private func signout() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.userUseCase.signOut()
                .subscribe(onSuccess: {
                    observable.onNext(.showOnboardingScene)
                }, onFailure: { error in
                    observable.onNext(.showAlert(.signoutError))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func withdrawal() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.userUseCase.withdrawal()
                .subscribe(onSuccess: {
                    observable.onNext(.showOnboardingScene)
                }, onFailure: { error in
                    observable.onNext(.showAlert(.withdrawalError))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - Reactor
extension MyPageReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchUser()
            
        case let .didSelectRow(indexPath):
            return didSelectRow(indexPath) ?? .just(.showAlert(.warning))
            
        case .signOut:
            return signout()
            
        case .withdrawal:
            return withdrawal()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadTableViewData:
            state.reloadTableViewData = Void()
            
        case .showAlarmViewController:
            showAlarmViewController()
            
        case .showAppPolicyViewController:
            showPolicyViewController(.app)
            
        case .showPrivacyPolicyViewController:
            showPolicyViewController(.privacy)
            
        case .showOpensourceLicenseViewController:
            showOpensourceLicenseViewController()
            
        case .showOnboardingScene:
            showOnboardingScene()
            state.dismiss = true
            
        case let .showAlert(myPageAlert):
            state.alert = myPageAlert
        }
        return state
    }
}

// MARK: - Flow Action
extension MyPageReactor {
    private func showAlarmViewController() {
        flowAction.showAlarmSettingViewController()
    }
    
    private func showPolicyViewController(_ policyType: PolicyType) {
        flowAction.showPolicyViewController(policyType)
    }
    
    private func showOpensourceLicenseViewController() {
        flowAction.showOpenSourceLicenseViewController()
    }
    
    private func showOnboardingScene() {
        flowAction.showOnboardingScene()
    }
}

// MARK: - MyPageAdapter TableViewDataSource
extension MyPageReactor: MyPageAdapterDataSource {
    public func numberOfSections() -> Int {
        return isSigned ? 3 : 2
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
