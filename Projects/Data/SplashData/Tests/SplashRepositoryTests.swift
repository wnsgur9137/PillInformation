//
//  SplashRepositoryTests.swift
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

@testable import SplashData
@testable import SplashDomain

final class SplashRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var splashRepository: ApplicationSplashRepository
        
        describe("📦 Create ApplicationSplashRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                splashRepository = DefaultApplicationSplashRepository(network: networkManager)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                splashRepository = nil
            }
            
            context("🟢 Device Check") {
                it("✅ Load Device Check") {
                    let observer = scheduler.createObserver(DeviceCheckResult.self)
                    
                    let expectedToken: String = "Token"
                    
                    splashRepository.deviceCheck(expectedToken)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(deviceCheck):
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute show signin flag") {
                it("✅ Load Signin flag") {
                    let observer = scheduler.createObserver(Bool.self)
                    
                    splashRepository.executeIsNeedSignIn()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(isShowSignin):
                        expect(isShowSignin).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute show alarm tab flag") {
                it("✅ Load Alarm tab flag") {
                    let observer = scheduler.createObserver(Bool.self)
                    
                    splashRepository.executeIsShowAlarmTab()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(isShowAlamTab):
                        expect(isShowAlamTab).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
        } // describe
    } // spec
}
