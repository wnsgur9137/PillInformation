//
//  HomeRecommendPillTests.swift
//  HomeTests
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

@testable import HomeData
@testable import HomeDomain
@testable import HomePresentation
@testable import BasePresentation

final class HomeRecommendPillTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var reactor: HomeRecommendReactor!
        
        func test_showSearchDetailViewController(_: PillInfoModel) { }
        func test_showSearchTab() { }
        func test_showShapeSearchViewController() { }
        
        describe("📦 Create HomeRecommendReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let recommendPillRepository = DefaultRecommendPillRepository(networkManager: networkManager)
                let recommendPillUseCase = DefaultRecommendPillUseCase(with: recommendPillRepository)
                let flowAction = HomeRecommendFlowAction(
                    showSearchDetailViewController: test_showSearchDetailViewController,
                    showSearchTab: test_showSearchTab,
                    showShapeSearchViewController: test_showShapeSearchViewController
                )
                reactor = HomeRecommendReactor(
                    with: recommendPillUseCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 ViewDidLoad") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { HomeRecommendReactor.Action.loadRecommendPills }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recommend pill count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.state
                        .map { $0.recommendPillCount }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(10, 2)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
