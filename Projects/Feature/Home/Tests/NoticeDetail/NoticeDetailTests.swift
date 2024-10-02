//
//  NoticeDetailTests.swift
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

extension NoticeModel: Equatable {
    public static func == (lhs: NoticeModel, rhs: NoticeModel) -> Bool {
        return (lhs.title == rhs.title &&
                lhs.writer == rhs.writer &&
                lhs.content == rhs.content &&
                lhs.writedDate == rhs.writedDate)
                
    }
}

final class NoticeDetailTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var reactor: NoticeDetailReactor!
        
        func test_showNoticeDetailViewController(_: NoticeModel) { }
        func test_popViewController(_: Bool) { }
        func test_showSearchTAb() { }
        func test_showSearchShapeViewController() { }
        
        describe("📦 Create NoticeDetailReactor") {
            let noticeModelMock: NoticeModel = .init(
                title: "TestNotice",
                writer: "TestWriter",
                content: "TestTestTestTestTest\nTestTest\nTest",
                writedDate: Date()
            )
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let noticeRepository = DefaultNoticeRepository(networkManager: networkManager)
                let noticeUseCase = DefaultNoticeUseCase(with: noticeRepository)
                let flowAction = NoticeDetailFlowAction(
                    showNoticeDetailViewController: test_showNoticeDetailViewController,
                    popViewController: test_popViewController,
                    showSearchTab: test_showSearchTAb,
                    showSearchShapeViewController: test_showSearchShapeViewController
                )
                reactor = NoticeDetailReactor(
                    notice: noticeModelMock,
                    noticeUseCase: noticeUseCase,
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
                        .map { NoticeDetailReactor.Action.loadNotice }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load notice") {
                    let observer = scheduler.createObserver(NoticeModel.self)
                    
                    reactor.state
                        .filter { $0.notice.isNotNull }
                        .map { $0.notice! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let exceptedEvents: [Recorded<Event<NoticeModel>>] = [
                        .next(10, noticeModelMock)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(exceptedEvents))
                }
            }
        } // describe
    } // sepc
}
