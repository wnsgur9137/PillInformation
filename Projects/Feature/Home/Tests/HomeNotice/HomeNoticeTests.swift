//
//  HomeNoticeTests.swift
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

final class HomeNoticeTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var reactor: HomeNoticeReactor!
        
        func test_showNoticeDetailViewController(_: NoticeModel) { }
        
        describe("📦 Create HomeNoticeReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let noticeRepository = DefaultNoticeRepository(networkManager: networkManager)
                let noticeUseCase = DefaultNoticeUseCase(with: noticeRepository)
                let flowAction = HomeNoticeFlowAction(showNoticeDetailViewController: test_showNoticeDetailViewController)
                reactor = HomeNoticeReactor(
                    with: noticeUseCase,
                    flowAction: flowAction
                )
            }
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 Load notices") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { HomeNoticeReactor.Action.loadNotices }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load notices") {
                    let observer = scheduler.createObserver(Int.self)
                    reactor.state
                        .filter { $0.noticeCount.isNotNull }
                        .map { $0.noticeCount! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(10, 5)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
