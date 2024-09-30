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

fileprivate enum MyPageSection: Int, CaseIterable {
    case appSetting
    case appInfo
    case accountOption
    
    enum AppSettingRows: Int, CaseIterable {
        case localization
        case screenMode
        case appAlarm
        
        static func header() -> String {
            Constants.MyPage.setting
        }
        
        func title() -> String {
            switch self {
            case .localization: Constants.MyPage.localizationSetting
            case .screenMode: Constants.MyPage.screenModeSetting
            case .appAlarm: Constants.MyPage.appAlarmSetting
            }
        }
    }
    
    enum AppInfoRows: Int, CaseIterable {
//        case appPolicy
//        case privacyPolicy
        case opensourceLicence
        
        static func header() -> String {
            Constants.MyPage.policy
        }
        
        func title() -> String {
            switch self {
//            case .appPolicy: return Constants.MyPage.appPolicy
//            case .screenMode: return Constants.MyPage.privacyPolicy
            case .opensourceLicence: return Constants.MyPage.opensourceLicense
            }
        }
    }
    
    enum AccountOptionRows: Int, CaseIterable {
        case signout
        case withdrawal
        
        static func header() -> String {
            Constants.MyPage.userInfo
        }
        
        func title() -> String {
            switch self {
            case .signout: Constants.MyPage.signout
            case .withdrawal: Constants.MyPage.withdrawal
            }
        }
    }
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
        case showLocalizationSettingViewController
        case showScreenModeSettingViewController
        case showAlarmSettingViewController
        case showAppPolicyViewController
        case showPrivacyPolicyViewController
        case showOpensourceLicenseViewController
        case showOnboardingScene
        case showAlert(MyPageAlert)
    }
    
    public struct State {
        @Pulse var tableViewSections: [MyPageSectionItem] = []
        @Pulse var reloadTableViewData: Void?
        @Pulse var alert: MyPageAlert?
        @Pulse var dismiss: Bool?
    }
    
    public var initialState = State()
    private var isSigned: Bool = false
    private let isShowAlarmSettingView: Bool
    private let userUseCase: UserUseCase
    private let flowAction: MyPageFlowAction
    private let disposeBag = DisposeBag()
    
    public init(with useCase: UserUseCase,
                isShowAlarmSettingView: Bool,
                flowAction: MyPageFlowAction) {
        self.userUseCase = useCase
        self.isShowAlarmSettingView = isShowAlarmSettingView
        self.flowAction = flowAction
    }
    
    private func didSelectRow(_ indexPath: IndexPath) -> Observable<Mutation>? {
        guard let section = MyPageSection(rawValue: indexPath.section) else { return nil }
        switch section {
        case .appSetting:
            guard let row = MyPageSection.AppSettingRows(rawValue: indexPath.row) else { break }
            switch row {
            case .localization: return .just(.showLocalizationSettingViewController)
            case .screenMode: return .just(.showScreenModeSettingViewController)
            case .appAlarm: return .just(.showAlarmSettingViewController)
            }
            
        case .appInfo:
            guard let row = MyPageSection.AppInfoRows(rawValue: indexPath.row) else { break }
            switch row {
//            case .appPolicy: return .just(.showAppPolicyViewController)
//            case .privacyPolicy: return .just(.showPrivacyPolicyViewController)
            case .opensourceLicence: return .just(.showOpensourceLicenseViewController)
            }
            
        case .accountOption:
            guard let row = MyPageSection.AccountOptionRows(rawValue: indexPath.row) else { break }
            switch row {
            case .signout: return .just(.showAlert(.signout))
            case .withdrawal: return .just(.showAlert(.withdrawal))
            }
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
    
    private func makeTableViewSections() -> [MyPageSectionItem] {
        let sections: [MyPageSection] = isSigned ? [.appSetting, .appInfo, .accountOption] : [.appSetting, .appInfo]
        return sections.map { section in
            switch section {
            case .appSetting:
                return MyPageSectionItem(
                    header: MyPageSection.AppSettingRows.header(),
                    items: MyPageSection.AppSettingRows.allCases.map {
                        $0.title()
                    }
                )
            case .appInfo:
                return MyPageSectionItem(
                    header: MyPageSection.AppInfoRows.header(),
                    items: MyPageSection.AppInfoRows.allCases.map { $0.title() }
                )
            case .accountOption:
                return MyPageSectionItem(
                    header: MyPageSection.AccountOptionRows.header(),
                    items: MyPageSection.AccountOptionRows.allCases.map { $0.title() }
                )
            }
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
            state.tableViewSections = makeTableViewSections()
            state.reloadTableViewData = Void()
            
        case .showLocalizationSettingViewController:
            showLocalizationSettingViewController()
            
        case .showScreenModeSettingViewController:
            showScreenModeSettingViewController()
            
        case .showAlarmSettingViewController:
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
    private func showLocalizationSettingViewController() {
        
    }
    
    private func showScreenModeSettingViewController() {
        
    }
    
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

//// MARK: - MyPageAdapter TableViewDataSource
//extension MyPageReactor: MyPageAdapterDataSource {
//    public func numberOfSections() -> Int {
//        let allCasesCount = MyPageSection.allCases.count
//        return isSigned ? allCasesCount : allCasesCount - 1
//    }
//    
//    public func numberOfRows(in section: Int) -> Int {
//        guard let section = MyPageSection(rawValue: section) else { return 0 }
//        switch section {
//        case .appSetting:
//            var count = MyPageSection.AppSettingRows.allCases.count
//            return isShowAlarmSettingView ? count : count - 1
//        case .appInfo: return MyPageSection.AppInfoRows.allCases.count
//        case .accountOption: return MyPageSection.AccountOptionRows.allCases.count
//        }
//    }
//    
//    public func cellForRow(at indexPath: IndexPath) -> String? {
//        guard let section = MyPageSection(rawValue: indexPath.section) else { return nil }
//        switch section {
//        case .appSetting:
//            guard let row = MyPageSection.AppSettingRows(rawValue: indexPath.row) else { break }
//            switch row {
//            case .localization: return Constants.MyPage.localizationSetting
//            case .screenMode: return Constants.MyPage.screenModeSetting
//            case .appAlarm: return Constants.MyPage.appAlarmSetting
//            }
//            
//        case .appInfo:
//            guard let row = MyPageSection.AppInfoRows(rawValue: indexPath.row) else { break }
//            switch row {
////            case .appPolicy: return Constants.MyPage.appPolicy
////            case .privacyPolicy: return Constants.MyPage.privacyPolicy
//            case .opensourceLicence: return Constants.MyPage.opensourceLicense
//            }
//            
//        case .accountOption:
//            guard let row = MyPageSection.AccountOptionRows(rawValue: indexPath.row) else { break }
//            switch row {
//            case .signout: return Constants.MyPage.signout
//            case .withdrawal: return Constants.MyPage.withdrawal
//            }
//        }
//        return nil
//    }
//    
//    public func titleForHeader(in section: Int) -> String? {
//        guard let section = MyPageSection(rawValue: section) else { return nil }
//        switch section {
//        case .appSetting: return Constants.MyPage.setting
//        case .appInfo: return Constants.MyPage.policy
//        case .accountOption: return Constants.MyPage.userInfo
//        }
//    }
//}
