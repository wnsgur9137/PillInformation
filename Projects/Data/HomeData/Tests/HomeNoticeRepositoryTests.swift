//
//  HomeNoticeRepositoryTests.swift
//  HomeDataTests
//
//  Created by JunHyoek Lee on 8/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxNimble

@testable import HomeData
@testable import HomeDomain

final class HomeNoticeRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var noticeRepository: NoticeRepository!
        
        describe("📦 Create HomeNoticeRepository") {
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                noticeRepository = DefaultNoticeRepository(networkManager: networkManager)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                noticeRepository = nil
            }
            
            context("🟢 Execute Notice") {
                it("✅ Emit Notices") {
                    let observer = scheduler.createObserver([Notice].self)
                    
                    noticeRepository.executeNotices()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedNotices: [Notice] = [
                        Notice(
                            title: "TestTitle1",
                            writer: "TestNickname1",
                            content: "TestContent1",
                            writedDate: nil
                        ),
                        Notice(
                            title: "TestTitle2",
                            writer: "TestNickname2",
                            content: "TestContent2",
                            writedDate: nil
                        ),
                        Notice(
                            title: "TestTitle3",
                            writer: "TestNickname3",
                            content: "TestContent3",
                            writedDate: nil
                        ),
                        Notice(
                            title: "TestTitle4",
                            writer: "TestNickname4",
                            content: "TestContent4",
                            writedDate: nil
                        ),
                        Notice(
                            title: "TestTitle5",
                            writer: "TestNickname5",
                            content: "TestContent5",
                            writedDate: nil
                        ),
                    ]
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(notices):
                        notices.enumerated().forEach { (index, notice) in
                            let expectedNotice = expectedNotices[index]
                            expect(notice.title).to(equal(expectedNotice.title))
                            expect(notice.writer)
                                .to(equal(expectedNotice.writer))
                            expect(notice.content).to(equal(expectedNotice.content))
                            expect(notice.writedDate).to(beNil())
                        }
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
        } // describe
    } // spec
}

//final class HomeNoticeRepositoryTests: XCTestCase {
//    
//    var scheduler: TestScheduler!
//    var disposeBag: DisposeBag!
//    var noticeRepository: NoticeRepository!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        scheduler = TestScheduler(initialClock: 1000)
//        disposeBag = DisposeBag()
//        
//        let networkManager = test_NetworkManager(withFail: false).networkManager
//        noticeRepository = DefaultNoticeRepository(networkManager: networkManager)
//    }
//
//    override func tearDownWithError() throws {
//        scheduler = nil
//        disposeBag = nil
//        noticeRepository = nil
//        try super.tearDownWithError()
//    }
//    
//    func test_executeNotices() {
//        // given
//        let observer = scheduler.createObserver([Notice].self)
//        
//        // When
//        let single = noticeRepository.executeNotices()
//        single.asObservable()
//            .subscribe(observer)
//            .disposed(by: disposeBag)
//        
//        scheduler.start()
//        
//        // Then
//        let expectedNotices: [Notice] = [
//            Notice(
//                title: "TestTitle1",
//                writer: "TestNickname1",
//                content: "TestContent1",
//                writedDate: nil
//            ),
//            Notice(
//                title: "TestTitle2",
//                writer: "TestNickname2",
//                content: "TestContent2",
//                writedDate: nil
//            ),
//            Notice(
//                title: "TestTitle3",
//                writer: "TestNickname3",
//                content: "TestContent3",
//                writedDate: nil
//            ),
//            Notice(
//                title: "TestTitle4",
//                writer: "TestNickname4",
//                content: "TestContent4",
//                writedDate: nil
//            ),
//            Notice(
//                title: "TestTitle5",
//                writer: "TestNickname5",
//                content: "TestContent5",
//                writedDate: nil
//            ),
//        ]
//        
//        observer.events.forEach { notice in
//            switch notice.value {
//            case let .next(notices):
//                notices.enumerated().forEach { (index, notice) in
//                    let expectedNotice = expectedNotices[index]
//                    expect(notice.title).to(equal(expectedNotice.title))
//                    expect(notice.writer)
//                        .to(equal(expectedNotice.writer))
//                    expect(notice.content).to(equal(expectedNotice.content))
//                    expect(notice.writedDate).to(beNil())
//                }
//                return
//            case let .error(error):
//                XCTFail("Error: \(error)")
//                return
//            case .completed:
//                return
//            }
//        }
//    }
//}
