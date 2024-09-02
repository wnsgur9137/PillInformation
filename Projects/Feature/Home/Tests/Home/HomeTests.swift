//
//  HomeTests.swift
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

final class HomeTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var reactor: HomeReactor!
        
        func test_showSearchTab() { }
        func test_showShapeSearchViewController() { }
        func test_showMyPageViewController() { }
        
        describe("📦 Create HomeReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let network = test_NetworkManager(withFail: false).networkManager
                let noticeRepository = DefaultNoticeRepository(networkManager: network)
                let recommendPillRepository = DefaultRecommendPillRepository(networkManager: network)
                let noticeUseCase = DefaultNoticeUseCase(with: noticeRepository)
                let recommendPillUseCase = DefaultRecommendPillUseCase(with: recommendPillRepository)
                let flowAction = HomeFlowAction(
                    showSearchTab: test_showSearchTab,
                    showShapeSearchViewController: test_showShapeSearchViewController,
                    showMyPageViewController: test_showMyPageViewController
                )
                reactor = HomeReactor(
                    noticeUseCase: noticeUseCase,
                    recommendPillUseCase: recommendPillUseCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 Load Notices") {
                beforeEach {
                    
                }
                
                it("✅ ") {
                    
                }
            }
        } // describe
    } // sepc
}
