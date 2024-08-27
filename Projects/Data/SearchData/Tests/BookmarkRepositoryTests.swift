//
//  BookmarkRepositoryTests.swift
//  SearchDataTests
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
import RealmSwift

@testable import BaseData
@testable import SearchData
@testable import BaseDomain
@testable import SearchDomain

final class BookmarkRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var bookmarkRepository: BookmarkRepository!
        
        describe("📦 Create BookmarkRepositroy") {
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
            
            context("🟢 Execute Pill Seqs") {
                beforeEach {
                    bookmarkRepository.deleteAll()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅Load Pills") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    // Save expected pill info
                    let expectedCount = 5
                    for seq in 1...expectedCount {
                        let expectedPillInfo = PillInfo(
                            medicineSeq: seq,
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
                        bookmarkRepository.savePill(pillInfo: expectedPillInfo)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    bookmarkRepository.executePillSeqs()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(seqs):
                        expect(seqs).toNot(beNil())
                        expect(seqs.count).to(equal(expectedCount))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Save Pill") {
                beforeEach {
                    bookmarkRepository.deleteAll()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load Pils") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    // Save expected pill info
                    let expectedPillInfo = PillInfo(
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
                    bookmarkRepository.savePill(pillInfo: expectedPillInfo)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(seqs):
                        expect(seqs).to(contain(expectedPillInfo.medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete pill") {
                beforeEach {
                    bookmarkRepository.deleteAll()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load Pills") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    // Save expected pill info
                    let expectedPillInfo = PillInfo(
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
                    bookmarkRepository.savePill(pillInfo: expectedPillInfo)
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    bookmarkRepository.deletePill(medicineSeq: expectedPillInfo.medicineSeq)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(seqs):
                        expect(seqs).toNot(contain(expectedPillInfo.medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete All") {
                it("✅ Load Pills") {
                    let observer = scheduler.createObserver([Int].self)
                    
                    bookmarkRepository.deleteAll()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    bookmarkRepository.executePillSeqs()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(seqs):
                        expect(seqs).to(beEmpty())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
        } // describe
    } // spec
}
