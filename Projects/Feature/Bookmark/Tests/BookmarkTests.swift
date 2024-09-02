//
//  BookmarkTests.swift
//  BookmarkTests
//
//  Created by JunHyoek Lee on 8/30/24.
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

@testable import BookmarkData
@testable import BookmarkDomain
@testable import BasePresentation
@testable import BookmarkPresentation

final class BookmarkTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: BookmarkUseCase!
        var reactor: BookmarkReactor!
        
        func test_showSearchShapeViewController() { }
        func test_showPillDetailViewController(_: PillInfoModel) { }
        func test_showMypageViewController() { }
        
        describe("📦 Create BookmarkReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let bookmarkStorage: BookmarkStorage = DefaultBookmarkStorage(testRealm: realm)
                let bookmarkRepository: BookmarkRepository = DefaultBookmarkRepository(bookmarkStorage: bookmarkStorage)
                useCase = DefaultBookmarkUseCase(bookmarkRepository: bookmarkRepository)
                let flowAction = BookmarkFlowAction(
                    showSearchShapeViewController: test_showSearchShapeViewController,
                    showPillDetailViewController: test_showPillDetailViewController,
                    showMyPageViewController: test_showMypageViewController
                )
                reactor = BookmarkReactor(
                    bookmarkUseCase: useCase,
                    flowAction: flowAction
                )
                
                let saveObservable = scheduler.createColdObservable([
                    .next(20, PillInfoModel(
                        medicineSeq: 0,
                        medicineName: "medicineName",
                        entpSeq: 1,
                        entpName: "entpName",
                        chart: nil,
                        medicineImage: "medicineImage",
                        printFront: nil,
                        printBack: nil,
                        medicineShape: "medicineShape",
                        colorClass1: nil,
                        colorClass2: nil,
                        lineFront: nil,
                        lineBack: nil,
                        lengLong: nil,
                        lengShort: nil,
                        thick: nil,
                        imgRegistTs: 1,
                        classNo: nil,
                        className: nil,
                        etcOtcName: "ectOtcName",
                        medicinePermitDate: 123,
                        formCodeName: nil,
                        markCodeFrontAnal: nil,
                        markCodeBackAnal: nil,
                        markCodeFrontImg: nil,
                        markCodeBackImg: nil,
                        changeDate: nil,
                        markCodeFront: nil,
                        markCodeBack: nil,
                        medicineEngName: nil,
                        ediCode: nil
                    )),
                    .next(40, PillInfoModel(
                        medicineSeq: 1,
                        medicineName: "medicineName",
                        entpSeq: 1,
                        entpName: "entpName",
                        chart: nil,
                        medicineImage: "medicineImage",
                        printFront: nil,
                        printBack: nil,
                        medicineShape: "medicineShape",
                        colorClass1: nil,
                        colorClass2: nil,
                        lineFront: nil,
                        lineBack: nil,
                        lengLong: nil,
                        lengShort: nil,
                        thick: nil,
                        imgRegistTs: 1,
                        classNo: nil,
                        className: nil,
                        etcOtcName: "ectOtcName",
                        medicinePermitDate: 123,
                        formCodeName: nil,
                        markCodeFrontAnal: nil,
                        markCodeBackAnal: nil,
                        markCodeFrontImg: nil,
                        markCodeBackImg: nil,
                        changeDate: nil,
                        markCodeFront: nil,
                        markCodeBack: nil,
                        medicineEngName: nil,
                        ediCode: nil
                    )),
                    .next(60, PillInfoModel(
                        medicineSeq: 2,
                        medicineName: "medicineName",
                        entpSeq: 1,
                        entpName: "entpName",
                        chart: nil,
                        medicineImage: "medicineImage",
                        printFront: nil,
                        printBack: nil,
                        medicineShape: "medicineShape",
                        colorClass1: nil,
                        colorClass2: nil,
                        lineFront: nil,
                        lineBack: nil,
                        lengLong: nil,
                        lengShort: nil,
                        thick: nil,
                        imgRegistTs: 1,
                        classNo: nil,
                        className: nil,
                        etcOtcName: "ectOtcName",
                        medicinePermitDate: 123,
                        formCodeName: nil,
                        markCodeFrontAnal: nil,
                        markCodeBackAnal: nil,
                        markCodeFrontImg: nil,
                        markCodeBackImg: nil,
                        changeDate: nil,
                        markCodeFront: nil,
                        markCodeBack: nil,
                        medicineEngName: nil,
                        ediCode: nil
                    ))
                ])
                saveObservable
                    .flatMapLatest { pillInfo in
                        return useCase.savePill(pillInfo: pillInfo)
                    }
                    .subscribe(onError: { error in
                        XCTFail("Error: \(error)")
                    })
                    .disposed(by: disposeBag)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
            }
            
            context("🟢 viewWillAppear") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ()),
                        .next(30, ()),
                        .next(50, ()),
                        .next(70, ()),
                    ])
                    observable
                        .map { BookmarkReactor.Action.loadBookmarkPills }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load bookmark pill count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.state
                        .filter { $0.bookmarkPillCount != nil }
                        .map { $0.bookmarkPillCount! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(10, 0),
                        .next(30, 1),
                        .next(50, 2),
                        .next(70, 3)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Delete") {
                beforeEach {
                    let deleteObservable = scheduler.createColdObservable([
                        .next(100, (IndexPath(row: 0, section: 0)))
                    ])
                    deleteObservable
                        .map { indexPath in
                            BookmarkReactor.Action.deleteRow(indexPath)
                        }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let loadObservable = scheduler.createColdObservable([
                        .next(80, ()),
                    ])
                    loadObservable
                        .map { BookmarkReactor.Action.loadBookmarkPills }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load bookmark count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.state
                        .filter { $0.bookmarkPillCount != nil }
                        .map { $0.bookmarkPillCount! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(80, 3),
                        .next(100, 2)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Delete all") {
                beforeEach {
                    let loadObservable = scheduler.createColdObservable([
                        .next(80, ())
                    ])
                    loadObservable
                        .map { BookmarkReactor.Action.loadBookmarkPills }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let deleteAllObservable = scheduler.createColdObservable([
                        .next(100, ())
                    ])
                    deleteAllObservable
                        .map { BookmarkReactor.Action.deleteAll }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load bookmark count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.state
                        .filter { $0.bookmarkPillCount != nil }
                        .map { $0.bookmarkPillCount! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(80, 3),
                        .next(100, 0)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
