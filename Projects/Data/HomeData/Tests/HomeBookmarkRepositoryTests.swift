//
//  HomeBookmarkRepositoryTests.swift
//  HomeDataTests
//
//  Created by JUNHYEOK LEE on 8/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxNimble
import RealmSwift

@testable import HomeData
@testable import BaseData
@testable import BaseDomain

final class HomeBookmarkRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var bookmarkRepository: BookmarkRepository!
        
        describe("📦 Create HomeBookmarkRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let bookmarkStorage = DefaultBookmarkStorage(testRealm: realm)
                bookmarkRepository = DefaultBookmarkRepository(bookmarkStorage: bookmarkStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                bookmarkRepository = nil
            }
            
            context("🟢 Save Pill Seqs") {
                it("✅ Emit pill Info") {
                    let pillInfo = PillInfo(
                        medicineSeq: 123,
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
                    )
                    
                    let observer = scheduler.createObserver([Int].self)
                    
                    bookmarkRepository.savePill(pillInfo: pillInfo)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(bookmarkSeqs):
                        expect(bookmarkSeqs).to(contain(pillInfo.medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
            
            context("🟢 Execute Pill Seqs") {
                it("✅ Emit Pill Seqs") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    bookmarkRepository.executePillSeqs()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(bookmarkSeqs):
                        expect(bookmarkSeqs.count).to(beGreaterThanOrEqualTo(0))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
            
            context("🟢 Delete Pill") {
                it("✅ Emit Delete Pill") {
                    let medicineSeq: Int = 123
                    
                    let observer = scheduler.createObserver([Int].self)
                    
                    bookmarkRepository.deletePill(medicineSeq: medicineSeq)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(bookmarkSeqs):
                        expect(bookmarkSeqs).toNot(contain(medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
            
            context("🟢 Delete All") {
                it("✅ Emit Delete All Pills") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    bookmarkRepository
                        .deleteAll()
                        .flatMap {
                            return bookmarkRepository.executePillSeqs()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(medicineSeqs):
                        expect(medicineSeqs).to(beEmpty())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                    
                } // it
            } // context
        } // describe
    } // sepc
}

