//
//  SearchRepositoryTests.swift
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

@testable import SearchData
@testable import BaseData
@testable import SearchDomain
@testable import BaseDomain

final class SearchRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var searchRepository: SearchRepository!
        
        describe("📦 Create SearchRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let hitHistoriesStorage: PillHitHistoryStorage =  DefaultPillHitHistoryStorage()
                searchRepository = DefaultSearchRepository(networkManager: networkManager, hitHistoriesStorage: hitHistoriesStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                searchRepository = nil
            }
            
            context("🟢 Execute pill") {
                it("✅ Load pill infos ") {
                    let observer = scheduler.createObserver([PillInfo].self)
                    
                    let expectedKeyword: String = "테스트"
                    
                    searchRepository.executePill(keyword: expectedKeyword)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillInfos):
                        expect(pillInfos).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute pill (shape)") {
                it("✅ Load pill infos") {
                    let observer = scheduler.createObserver([PillInfo].self)
                    
                    let expectedKeyword: String = "테스트"
                    
                    let expectedPillShape = PillShape(shapes: ["장방형"], colors: ["NULL"], lines: nil, codes: nil)
                    
                    searchRepository.executePill(shapeInfo: expectedPillShape)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(pillInfos):
                        expect(pillInfos).toNot(beNil())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute pill description") {
                it("✅ Load pill description") {
                    let observer = scheduler.createObserver(PillDescription?.self)
                    
                    let expectedMedicineSeq: Int = 123
                    
                    searchRepository
                        .executePillDescription(expectedMedicineSeq)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(description):
                        expect(description).toNot(beNil())
                        expect(description?.medicineSeq).to(equal(expectedMedicineSeq))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute pill hits") {
                it("✅ Load pill hits") {
                    let observer = scheduler.createObserver(PillHits.self)
                    
                    let expectedMedicineSeq: Int = 123
                    
                    searchRepository.executePillHits(medicineSeq: expectedMedicineSeq)
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
                        expect(pillHits).toNot(beEmpty())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
        } // describe
    } // spec
}
