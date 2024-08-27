//
//  BookmarkRepositoryTests.swift
//  BookmarkDataTests
//
//  Created by JunHyoek Lee on 8/26/24.
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

@testable import BookmarkData
@testable import BaseDomain
@testable import BookmarkDomain

final class BookmarkRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var bookmarkRepository: BookmarkDomain.BookmarkRepository!
        
        describe("📦 Create BookmarkRepository") {
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
                    let observer = scheduler.createObserver(Void.self)
                    bookmarkRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case let .error(error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
                
                it("🟢 Load Pill Seqs") {
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
                    case let .next(seqs):
                        expect(seqs.count).to(beGreaterThanOrEqualTo(0))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute Pill Infos") {
                
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    bookmarkRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case let .error(error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
                
                it("🟢 Load Pill Infos") {
                    let observer = scheduler.createObserver([PillInfo].self)
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
                        .subscribe(onNext: { _ in })
                        .disposed(by: disposeBag)
                    bookmarkRepository.executePills()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillInfos):
                        expect(pillInfos.count).to(beGreaterThan(0))
                        expect(pillInfos.map { $0.medicineSeq }).to(contain(expectedPillInfo.medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Save Pill") {
                
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    bookmarkRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case let .error(error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
                
            }
            
            context("🟢 Save Duplicated Pill") {
                
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    bookmarkRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case let .error(error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
                
            }
            
            context("🟢 Delete Pill") {
                
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    bookmarkRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case let .error(error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
                
                let observer = scheduler.createObserver([Int].self)
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
                    .subscribe(onNext: { _ in })
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
            
            context("🟢 Delete All") {
                let observer = scheduler.createObserver([Int].self)
                bookmarkRepository.deleteAll()
                    .asObservable()
                    .subscribe(onNext: { _ in })
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
            }
        }
    }
}
