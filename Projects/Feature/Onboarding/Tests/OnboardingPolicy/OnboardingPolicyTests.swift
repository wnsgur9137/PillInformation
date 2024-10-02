//
//  OnboardingPolicyTests.swift
//  OnboardingTests
//
//  Created by JunHyoek Lee on 9/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxNimble
import RxSwift
import RxCocoa
import RxTest
import RealmSwift

@testable import OnboardingData
@testable import BaseData
@testable import OnboardingDomain
@testable import OnboardingPresentation
@testable import BasePresentation

extension UserModel: Equatable {
    public static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return (lhs.id == rhs.id &&
                lhs.isAgreeAppPolicy == rhs.isAgreeAppPolicy &&
                lhs.isAgreeAgePolicy == rhs.isAgreeAgePolicy &&
                lhs.isAgreePrivacyPolicy == rhs.isAgreePrivacyPolicy &&
                lhs.isAgreeDaytimeNoti == rhs.isAgreeDaytimeNoti &&
                lhs.isAgreeNighttimeNoti == rhs.isAgreeNighttimeNoti &&
                lhs.accessToken == rhs.accessToken &&
                lhs.refreshToken == rhs.refreshToken &&
                lhs.social == rhs.social)
    }
}

final class OnboardingPolicyTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var userUseCase: UserUseCase!
        var reactor: OnboardingPolicyReactor!
        var userDefaults: UserDefaults!
        
        func test_popViewController(_: Bool) { }
        func test_showMainScene() { }
        func test_showPolicyViewController(_: PolicyReactor.PolicyType) { }
        
        describe("📦 Create OnboardingPolicyReactor") {
            let userModelMock: UserModel = .init(
                id: 0,
                isAgreeAppPolicy: false,
                isAgreeAgePolicy: false,
                isAgreePrivacyPolicy: false,
                isAgreeDaytimeNoti: true,
                isAgreeNighttimeNoti: false,
                accessToken: "TestToken",
                refreshToken: "TestToken",
                social: "TestSocial"
            )
            let showAlarmFlag: Bool = false
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                userDefaults = UserDefaults(suiteName: "TestUserDefaults")!
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let userStorage = DefaultUserStorage(testRealm: realm)
                let userRepository = DefaultUserRepository(
                    networkManager: networkManager,
                    userStorage: userStorage
                )
                let userOnboardingRepository = DefaultUserOnboardingRepository(
                    userDefault: userDefaults,
                    userRepository: userRepository
                )
                userUseCase = DefaultUserUseCase(with: userOnboardingRepository)
                let flowAction = OnboardingPolicyFlowAction(
                    popViewController: test_popViewController,
                    showMainScene: test_showMainScene,
                    showPolicyViewController: test_showPolicyViewController
                )
                reactor = OnboardingPolicyReactor(
                    user: userModelMock,
                    isShowAlarmPrivacy: showAlarmFlag,
                    userUseCase: userUseCase,
                    flowAction: flowAction
                )
                
                let saveObservable = scheduler.createColdObservable([
                    .next(10, userModelMock)
                ])
                saveObservable
                    .flatMapLatest { userModelMock in
                        return userUseCase.saveStorage(userModelMock)
                    }
                    .subscribe(onError: { error in
                        XCTFail("Error: \(error)")
                    })
                    .disposed(by: disposeBag)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
                userDefaults.removePersistentDomain(forName: "TestUserDefaults")
                userDefaults = nil
            }
            
            context("🟢 ViewDidLoad") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(0, ())
                    ])
                    observable
                        .map { OnboardingPolicyReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                it("✅ Check alarm privacy flag") {
                    let observer = scheduler.createObserver(Bool.self)
                    
                    reactor.state
                        .filter { $0.isShowAlarmPrivacy.isNotNull }
                        .map { $0.isShowAlarmPrivacy! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Bool>>] = [
                        .next(0, showAlarmFlag)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped confirm button") {
                beforeEach {
                    let agreeObservable = scheduler.createColdObservable([
                        .next(30, ())
                    ])
                    agreeObservable
                        .flatMapLatest { _ in
                            return Observable.concat(
                                .just(OnboardingPolicyReactor.Action.didTapAppPolicy),
                                .just(OnboardingPolicyReactor.Action.didTapAgePolicy),
                                .just(OnboardingPolicyReactor.Action.didTapPrivacyPolicy)
                            )
                        }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let observable = scheduler.createColdObservable([
                        .next(50, ())
                    ])
                    observable
                        .map {
                            OnboardingPolicyReactor.Action.didTapConfirmButton
                        }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updated app policy") {
                    let appPolicyObserver = scheduler.createObserver(Bool.self)
                    
                    reactor.state
                        .map { $0.isCheckedAppPolicy }
                        .asObservable()
                        .skip(1)
                        .subscribe(appPolicyObserver)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Bool>>] = [
                        .next(30, true),
                        .next(30, true),
                        .next(30, true),
                        .next(50, true),
                    ]
                    
                    scheduler.start()
                    
                    expect(appPolicyObserver.events).to(equal(expectedEvents))
                }
                
                it("✅ Updated age policy") {
                    let agePolicyObserver = scheduler.createObserver(Bool.self)
                    
                    reactor.state
                        .map { $0.isCheckedAgePolicy }
                        .asObservable()
                        .skip(1)
                        .subscribe(agePolicyObserver)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Bool>>] = [
                        .next(30, false),
                        .next(30, true),
                        .next(30, true),
                        .next(50, true),
                    ]
                    
                    scheduler.start()
                    
                    expect(agePolicyObserver.events).to(equal(expectedEvents))
                }
                
                it("✅ Updated privacy policy") {
                    let privacyPolicyObserver = scheduler.createObserver(Bool.self)
                    
                    reactor.state
                        .map { $0.isCheckedPrivacyPolicy }
                        .asObservable()
                        .skip(1)
                        .subscribe(privacyPolicyObserver)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Bool>>] = [
                        .next(30, false),
                        .next(30, false),
                        .next(30, true),
                        .next(50, true),
                    ]
                    
                    scheduler.start()
                    
                    expect(privacyPolicyObserver.events).to(equal(expectedEvents))
                }
                
                it("✅ Updated user storage") {
                    let loadObservable = scheduler.createColdObservable([
                        .next(50, (userModelMock.id))
                    ])
                    let observer = scheduler.createObserver(UserModel.self)
                    loadObservable
                        .flatMapLatest { userID in
                            return userUseCase.executeUser(userID: userID)
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<UserModel>>] = [
                        .next(50, .init(
                            id: userModelMock.id,
                            isAgreeAppPolicy: true,
                            isAgreeAgePolicy: true,
                            isAgreePrivacyPolicy: true,
                            isAgreeDaytimeNoti: userModelMock.isAgreeDaytimeNoti,
                            isAgreeNighttimeNoti: userModelMock.isAgreeNighttimeNoti,
                            accessToken: userModelMock.accessToken,
                            refreshToken: userModelMock.refreshToken,
                            social: userModelMock.social
                        ))
                    ]
                    
                    scheduler.start()
                    
//                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped all agree button") {
                beforeEach {
                    let updateObservable = scheduler.createColdObservable([
                        .next(30, ())
                    ])
                    updateObservable
                        .map { OnboardingPolicyReactor.Action.didTapAllAgreeButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updated user info storage") {
                    let loadObservable = scheduler.createColdObservable([
                        .next(50, userModelMock.id)
                    ])
                    let observer = scheduler.createObserver(UserModel.self)
                    loadObservable
                        .flatMapLatest { userID in
                            return userUseCase.executeUser(userID: userID)
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectEvents: [Recorded<Event<UserModel>>] = [
                        .next(50,  .init(
                            id: userModelMock.id,
                            isAgreeAppPolicy: true,
                            isAgreeAgePolicy: true,
                            isAgreePrivacyPolicy: true,
                            isAgreeDaytimeNoti: userModelMock.isAgreeDaytimeNoti,
                            isAgreeNighttimeNoti: userModelMock.isAgreeNighttimeNoti,
                            accessToken: userModelMock.accessToken,
                            refreshToken: userModelMock.refreshToken,
                            social: userModelMock.social
                        ))
                    ]
                    
//                    expect(observer.events).to(equal(expectEvents))
                }
            }
            
        } // describe
    } // sepc
}
