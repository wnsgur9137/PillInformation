//
//  MyPageUserRepositoryTests.swift
//  MyPageData
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

@testable import BaseData
@testable import MyPageData
@testable import BaseDomain
@testable import MyPageDomain

final class MyPageUserRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var userRepository: UserRepository!
        var userMyPageRepository: UserMyPageRepository!
        
        describe("📦 Create UserMyPageRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let userStorage = DefaultUserStorage(testRealm: realm)
                userRepository = DefaultUserRepository(networkManager: networkManager, userStorage: userStorage)
                userMyPageRepository = DefaultUserMyPageRepository(userRepository: userRepository)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                userMyPageRepository = nil
            }
            
            context("🟢 Get user from network") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load user from network") {
                    let observer = scheduler.createObserver(BaseDomain.User.self)
                    
                    let expectedUserID: Int = 123
                    
                    userMyPageRepository.getUser(userID: expectedUserID)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next evet found")
                        return
                    }
                    switch result {
                    case let .next(user):
                        expect(user).toNot(beNil())
                        expect(user.id).to(equal(expectedUserID))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Post user") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load user from network") {
                    let observer = scheduler.createObserver(BaseDomain.User.self)
                    
                    let expectedUser = User(
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
                    
                    userMyPageRepository.postUser(expectedUser)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next evet found")
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
            
            context("🟢 Delete user to network") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Delete user to network") {
                    let observer = scheduler.createObserver(Void.self)
                    
                    let expectedUserID: Int = 123
                    
                    userMyPageRepository.deleteUser(userID: expectedUserID)
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
            
            context("🟢 Load user from storage") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load user from storage") {
                    let observer = scheduler.createObserver(BaseDomain.User.self)
                    
                    // Save expected user
                    let expectedUser = UserDTO(
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
                    
                    userMyPageRepository.fetchStorage(userID: expectedUser.id)
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
            
            context("🟢 Load first user from storage") {
                beforeEach {
                    userRepository.deleteStorage()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load first user from storage") {
                    let observer = scheduler.createObserver(BaseDomain.User.self)
                    
                    // Save expected user
                    let expectedUser = UserDTO(
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
                    
                    userMyPageRepository.fetchFirstUserStorage()
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
                
                it("✅ Load user from storage") {
                    let observer = scheduler.createObserver(BaseDomain.User.self)
                    
                    // Save expected user
                    let expectedUser = UserDTO(
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
                    
                    userMyPageRepository
                        .updateStorage(expectedUpdateUser)
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
                
                it("✅ Delete user to storage") {
                    let observer = scheduler.createObserver(Void.self)
                    
                    // Save expected user
                    let expectedUser = UserDTO(
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
                    
                    userMyPageRepository.deleteStorage(userID: expectedUser.id)
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
                } // it
            } // context
        } // describe
    } // spec
}
