//
//  PolicyTests.swift
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

@testable import OnboardingData
@testable import OnboardingDomain
@testable import OnboardingPresentation
@testable import BasePresentation

final class PolicyTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var flowAction: PolicyFlowAction!
        var reactor: PolicyReactor!
        
        func test_popViewController(_: Bool) { }
        
        describe("") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                flowAction = PolicyFlowAction(popViewController: test_popViewController)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 ViewDidLoad") {
                beforeEach {
                    reactor = PolicyReactor(
                        policyType: .app,
                        flowAction: flowAction
                    )
                    
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { PolicyReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load policy title") {
                    let observer = scheduler.createObserver(String?.self)
                    
                    reactor.state
                        .map { $0.policyTitle }
                        .asObservable()
                        .skip(1)
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<String?>>] = [
                        .next(10, Constants.Onboarding.appPolicy)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
                
                it("✅ Load policy content") {
                    let observer = scheduler.createObserver(String?.self)
                    
                    reactor.state
                        .map { $0.policy }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<String?>>] = [
                        .next(10, Constants.Onboarding.appPolicyContents)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 ViewDidLoad") {
                beforeEach {
                    reactor = PolicyReactor(
                        policyType: .privacy,
                        flowAction: flowAction
                    )
                    
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { PolicyReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load policy title") {
                    let observer = scheduler.createObserver(String?.self)
                    
                    reactor.state
                        .map { $0.policyTitle }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<String?>>] = [
                        .next(10, Constants.Onboarding.privacyPolicyTitle)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
                
                it("✅ Load policy content") {
                    let observer = scheduler.createObserver(String?.self)
                    
                    reactor.state
                        .map { $0.policy }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<String?>>] = [
                        .next(10, Constants.Onboarding.privacyPolicyContents)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
