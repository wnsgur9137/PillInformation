//
//  BookmarkSearchDetailRepositoryTests.swift
//  BookmarkDataTests
//
//  Created by JunHyoek Lee on 8/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxTest
import RxBlocking
import RxNimble

@testable import BookmarkData
@testable import BaseData
@testable import BookmarkDomain
@testable import BaseDomain

final class BookmarkSearchDetailRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var searchDetailRepository: SearchDetailRepository!
        
        describe("📦 Create SearchDetailRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let hitHistoryStorage = DefaultPillHitHistoryStorage()
                searchDetailRepository = DefaultSearchDetailRepository(networkManager: networkManager, hitHistoryStorage: hitHistoryStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                searchDetailRepository = nil
            }
            
            context("🟢 Execute Pill Description") {
                it("✅ Load Pill Descrpition") {
                    let medicineSeq: Int = 195700020
                    
                    let observer = scheduler.createObserver(PillDescription?.self)
                    
                    searchDetailRepository.executePillDescription(medicineSeq)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillDescription):
                        expect(pillDescription).toNot(beNil())
                        expect(pillDescription?.medicineSeq).to(equal(medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute Pill Hits") {
                it("✅ Load Pill Hits") {
                    let medicineSeq: Int = 123456
                    
                    let observer = scheduler.createObserver(PillHits.self)
                    
                    searchDetailRepository.executePillHits(medicineSeq: medicineSeq)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillHits):
                        expect(pillHits).toNot(beNil())
                        expect(pillHits.medicineSeq).to(equal(medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Post Pill Hits") {
                it("✅ Load Pill Hits") {
                    let medicineSeq: Int = 123456
                    let medicineName: String = "테스트레놀"
                    
                    let observer = scheduler.createObserver(PillHits.self)
                    
                    searchDetailRepository.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillHits):
                        expect(pillHits).toNot(beNil())
                        expect(pillHits.medicineSeq).to(equal(medicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Save Hit Histories") {
                it("✅ Load Hit Histories") {
                    
                    let expectedHits = [1, 2, 3]
                    
                    let hits = searchDetailRepository.saveHitHistories(expectedHits)
                    
                    expect(hits).to(equal(expectedHits))
                }
            }
            
            context("🟢 Save Duplicated Hit History") {
                it("✅ Load Hit Histories") {
                    let expectedHits1 = [1, 2, 3]
                    let expectedHits2 = [3, 4, 5]
                    let compactCount = (expectedHits1 + expectedHits2).compactMap { $0 }.count
                    
                    var hits = searchDetailRepository.saveHitHistories(expectedHits1)
                    
                    expect(hits).to(equal(expectedHits1))
                    
                    hits = searchDetailRepository.saveHitHistories(expectedHits2)
                    
                    expect(hits).to(contain(expectedHits1))
                    expect(hits).to(contain(expectedHits2))
                    expect(hits.count).to(equal(compactCount))
                }
            }
            
            context("🟢 Delete Hit History") {
                it("✅ Load Hit Histories") {
                    let expectedHit = 1
                    var hits = searchDetailRepository.saveHitHistories([expectedHit])
                    expect(hits).to(contain(expectedHit))
                    
                    hits = searchDetailRepository.deleteHitHistory(expectedHit)
                    expect(hits).toNot(contain(expectedHit))
                }
            }
            
            context("🟢 Delete All Hit Histories") {
                it("✅ Load Hit Histories") {
                    searchDetailRepository.deleteAllHitHistories()
                    
                    let hits = searchDetailRepository.loadHitHistories()
                    
                    expect(hits).to(beEmpty())
                } // it
            } // context
        } // describe
    } // spec
}
