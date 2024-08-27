//
//  HomeSearchDetailRepositoryTests.swift
//  HomeDataTests
//
//  Created by JunHyoek Lee on 8/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxTest
import RxNimble

@testable import HomeData
@testable import BaseData
@testable import HomeDomain

final class HomeSearchDetailRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var searchDetailRepository: SearchDetailRepository!
        
        describe("📦 Create HomeSearchDetailRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let hitHistoriesStorage = DefaultPillHitHistoryStorage()
                searchDetailRepository = DefaultSearchDetailRepository(networkManager: networkManager, hitHistoriesStorage: hitHistoriesStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                searchDetailRepository = nil
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
