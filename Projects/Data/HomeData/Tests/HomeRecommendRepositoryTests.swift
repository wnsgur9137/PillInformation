//
//  HomeRecommendRepositoryTests.swift
//  HomeDataTests
//
//  Created by JunHyoek Lee on 8/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxNimble

@testable import HomeData
@testable import HomeDomain

final class HomeRecommendRepositoryTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var recommendPillRepository: RecommendPillRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 1000)
        disposeBag = DisposeBag()
        let networkManager = test_NetworkManager(withFail: false).networkManager
        recommendPillRepository = DefaultRecommendPillRepository(networkManager: networkManager)
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        recommendPillRepository = nil
        try super.tearDownWithError()
    }
    
    func test_ExecuteRecommendPills() {
        recommendPillRepository.executeRecommendPills()
            .subscribe(onSuccess: { result in
                
            }, onFailure: { error in
                
            })
            .disposed(by: disposeBag)
    }
    
    func test_UpdatePillHits() {
        // given
        let medicineSeq: Int = 1
        let medicineName: String = "123"
        
        // when
        recommendPillRepository.updatePillHits(
            medicineSeq: medicineSeq,
            medicineName: medicineName
        )
        .subscribe(onSuccess: { result in
            
        }, onFailure: { error in
            
        })
        .disposed(by: disposeBag)
    }
}
