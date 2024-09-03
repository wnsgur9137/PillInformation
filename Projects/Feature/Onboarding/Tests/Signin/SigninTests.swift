//
//  SigninTests.swift
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

extension UserDTO: Equatable {
    public static func == (lhs: UserDTO, rhs: UserDTO) -> Bool {
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

final class SigninTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var userRepository: UserRepository!
        var useCase: UserUseCase!
        var reactor: SignInReactor!
        
        func test_showOnboardingPolicyViewController(_: UserModel) { }
        func test_showMainScene() { }
        
        describe("📦 Create Signin reactor") {
            let emailMock: String = "TestEmail@apple.com"
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let userStorage = DefaultUserStorage(testRealm: realm)
                let userDefaults = UserDefaults(suiteName: "TestUserDefaults")!
                userRepository = DefaultUserRepository(
                    networkManager: networkManager,
                    userStorage: userStorage
                )
                let userOnboardingRepository = DefaultUserOnboardingRepository(
                    userDefault: userDefaults,
                    userRepository: userRepository
                )
                useCase = DefaultUserUseCase(with: userOnboardingRepository)
                let flowAction = SignInFlowAction(
                    showOnboardingPolicyViewController: test_showOnboardingPolicyViewController,
                    showMainScene: test_showMainScene
                )
                reactor = SignInReactor(
                    with: useCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
            }
            
            context("🟢 Tapped apple login button") {
                beforeEach {
                    useCase.saveEmailToKeychain(emailMock)
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    let observable = scheduler.createColdObservable([
                        .next(10, ("TestToken"))
                    ])
                    observable
                        .map { token in SignInReactor.Action.didTapAppleLoginButton(token) }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                afterEach {
                    useCase.deleteEmailFromKeychain()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load user storage") {
                    let fetchFirstUserSubject: PublishSubject<Void> = .init()
                    let observer = scheduler.createObserver(UserDTO.self)
                    
                    fetchFirstUserSubject
                        .flatMapLatest {
                            return userRepository.fetchFirstUser()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<UserDTO>>] = [
                        .next(30, .init(
                            id: 0,
                            isAgreeAppPolicy: false,
                            isAgreeAgePolicy: false,
                            isAgreePrivacyPolicy: false,
                            isAgreeDaytimeNoti: false,
                            isAgreeNighttimeNoti: false,
                            accessToken: "TestToken",
                            refreshToken: "TestToken",
                            social: Social.apple.rawValue
                        ))
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
