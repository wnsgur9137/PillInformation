//
//  HomeRecommendRepositoryTests.swift
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
@testable import HomeDomain
@testable import BaseDomain

final class HomeRecommendRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var recommendPillRepository: RecommendPillRepository!
        
        describe("📦 Create HomeRecommendRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                recommendPillRepository = DefaultRecommendPillRepository(networkManager: networkManager)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                recommendPillRepository = nil
            }
            
            context("🟢 Execute Recommend Pills") {
                it("✅ Load Recommend Pills") {
                    let observer = scheduler.createObserver([PillInfo].self)
                    
                    recommendPillRepository.executeRecommendPills()
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
            
            context("🟢 Update Pill Hits") {
                it("✅ Load Pill Hits") {
                    let observer = scheduler.createObserver(PillHits.self)
                    
                    let medicineSeq: Int = 123456
                    let medicineName: String = "테스트레놀"
                    
                    recommendPillRepository.updatePillHits(medicineSeq: medicineSeq, medicineName: medicineName)
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
                        expect(pillHits.medicineName).to(equal(medicineName))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                } // it
            } // context
        } // describe
    } // spec
}
