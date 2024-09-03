//
//  SplashTests.swift
//  SplashTests
//
//  Created by JunHyoek Lee on 9/3/24.
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
import DeviceCheck

@testable import NetworkInfra
@testable import SplashData
@testable import BaseData
@testable import SplashDomain
@testable import SplashPresentation

final class SplashTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: SplashUseCase!
        var reactor: SplashReactor!
        
        func test_flowActionMethod() { }
        
        describe("📦 Create SplashReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = NetworkManager(withTest: true, withFail: false, baseURL: "")
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let userDefaults = UserDefaults(suiteName: "TestUserDefaults")!
                
                let applicationRepository = DefaultApplicationSplashRepository(network: networkManager)
                let userStorage = DefaultUserStorage(testRealm: realm)
                let userRepository = DefaultUserRepository(
                    networkManager: networkManager,
                    userStorage: userStorage
                )
                let splashUserDefaultsStorage = SplashUserDefaultStorage(userDefault: userDefaults)
                let userSplashRepository = DefaultUserSplashRepository(
                    networkManager: networkManager,
                    userRepository: userRepository,
                    splashUserDefaultStorage: splashUserDefaultsStorage
                )
                
                useCase = DefaultSplashUseCase(
                    applicationRepository: applicationRepository,
                    userRepository: userSplashRepository
                )
                let flowAction = SplashFlowAction(
                    showMainScene: test_flowActionMethod,
                    showOnboardingSceneSigninViewController: test_flowActionMethod,
                    showOnboardingScene: test_flowActionMethod
                )
                reactor = SplashReactor(
                    with: useCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 ViewDidLoad") {
                it("✅ ") {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    
                    observable
                        .subscribe(onNext: {
                            let device = DCDevice.current
                            guard device.isSupported else { return }
                            device.generateToken() { token, error  in
                                if let error = error {
                                    XCTFail("Error: \(error)")
                                }
                                guard let deviceTokenString = token?.base64EncodedString() else {
                                    XCTFail("token is nil")
                                    return
                                }
                                useCase.deviceCheck(deviceTokenString)
                                    .subscribe(onFailure: { error in
                                        XCTFail("Error: \(error)")
                                    })
                                    .disposed(by: disposeBag)
                            }
                        })
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                }
            }
            
            context("🟢 Check is shown onboarding") {
                it("✅ ") {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .flatMapLatest {
                            return useCase.isShownOnboarding()
                        }
                        .subscribe(onNext: { isShown in
                            expect(isShown).to(beTrue())
                        }, onError: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                }
            }
        } // describe
    } // sepc
}
