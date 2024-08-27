//
//  UserSplashRepositoryTests.swift
//  SplashDataTests
//
//  Created by JunHyoek Lee on 8/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxTest
import RxNimble
import RealmSwift

@testable import SplashData
@testable import BaseData
@testable import SplashDomain
@testable import BaseDomain

final class UserSplashRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var userRepository: UserRepository!
        var userSplashRepository: UserSplashRepository!
        
        describe("📦 Create UserSplashRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let userStorage = DefaultUserStorage(testRealm: realm)
                userRepository: UserRepository = DefaultUserRepository(networkManager: networkManager, userStorage: userStorage)
                let splashUserDefaultStorage = SplashUserDefaultStorage()
                userSplashRepository = DefaultUserSplashRepository(networkManager: networkManager, userRepository: userRepository, splashUserDefaultStorage: splashUserDefaultStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                userSplashRepository = nil
            }
            
            context("🟢 Signin") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load User") {
                    let observer = scheduler.createObserver(User.self)
                    
                    let expectedToken: String = "Token"
                    
                    userSplashRepository.signin(accessToken: expectedToken)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event fount")
                        return
                    }
                    switch result {
                    case let .next(user):
                        expect(user).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Fetch user from storage") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load User") {
                    let observer = scheduler.createObserver(User.self)
                    
                    // Save expected user
                    let expectedUser = User(
                        id: 123,
                        isAgreeAppPolicy: true,
                        isAgreeAgePolicy: true,
                        isAgreePrivacyPolicy: true,
                        isAgreeDaytimeNoti: false,
                        isAgreeNighttimeNoti: false,
                        accessToken: "accessToken",
                        refreshToken: "refreshToken",
                        social: "apple"
                    )
                    userRepository.saveStorage(expectedUser)
                        .subscribe(onSuccess: { _ in },
                                   onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    userSplashRepository.fetchUserStorage()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event fount")
                        return
                    }
                    switch result {
                    case let .next(user):
                        expect(user).toNot(beNil())
                        expect(user.id).to(equal(expectedUser.id))
                        expect(user.isAgreeAppPolicy).to(equal(expectedUser.isAgreeAppPolicy))
                        expect(user.isAgreeAgePolicy).to(equal(expectedUser.isAgreeAgePolicy))
                        expect(user.isAgreePrivacyPolicy).to(equal(expectedUser.isAgreePrivacyPolicy))
                        expect(user.isAgreeDaytimeNoti).to(equal(expectedUser.isAgreeDaytimeNoti))
                        expect(user.isAgreeNighttimeNoti).to(equal(expectedUser.isAgreeNighttimeNoti))
                        expect(user.accessToken).to(equal(expectedUser.accessToken))
                        expect(user.refreshToken).to(equal(expectedUser.refreshToken))
                        expect(user.social).to(equal(expectedUser.social))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Update user to storage") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load User") {
                    let observer = scheduler.createObserver(User.self)
                    
                    // Save expected user
                    let expectedUser = User(
                        id: 123,
                        isAgreeAppPolicy: true,
                        isAgreeAgePolicy: true,
                        isAgreePrivacyPolicy: true,
                        isAgreeDaytimeNoti: false,
                        isAgreeNighttimeNoti: false,
                        accessToken: "accessToken",
                        refreshToken: "refreshToken",
                        social: "apple"
                    )
                    userRepository.saveStorage(expectedUser)
                        .subscribe(onSuccess: { _ in },
                                   onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    let expectedUpdateUser = User(
                        id: 123,
                        isAgreeAppPolicy: true,
                        isAgreeAgePolicy: true,
                        isAgreePrivacyPolicy: true,
                        isAgreeDaytimeNoti: true,
                        isAgreeNighttimeNoti: true,
                        accessToken: "accessToken",
                        refreshToken: "refreshToken",
                        social: "apple"
                    )
                    
                    userSplashRepository.updateStorage(expectedUpdateUser)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event fount")
                        return
                    }
                    switch result {
                    case let .next(user):
                        expect(user).toNot(beNil())
                        expect(user.isAgreeDaytimeNoti).to(beTrue())
                        expect(user.isAgreeNighttimeNoti).to(beTrue())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete user to storage") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Delete User") {
                    let observer = scheduler.createObserver(Void.self)
                    
                    // Save expected user
                    let expectedUser = User(
                        id: 123,
                        isAgreeAppPolicy: true,
                        isAgreeAgePolicy: true,
                        isAgreePrivacyPolicy: true,
                        isAgreeDaytimeNoti: false,
                        isAgreeNighttimeNoti: false,
                        accessToken: "accessToken",
                        refreshToken: "refreshToken",
                        social: "apple"
                    )
                    userRepository.saveStorage(expectedUser)
                        .subscribe(onSuccess: { _ in },
                                   onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    userSplashRepository.deleteUserStorage()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
            }
            
            context("🟢 Load Onboarding flag") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load Onboarding flag") {
                    let observer = scheduler.createObserver(Bool.self)
                    userSplashRepository.isShownOnboarding()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(isShownOnboarding):
                        expect(isShownOnboarding).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
        } // describe
    } // spec
}
