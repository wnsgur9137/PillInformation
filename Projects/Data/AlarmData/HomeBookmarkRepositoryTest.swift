//
//  HomeBookmarkRepositoryTest.swift
//  HomeDataTests
//
//  Created by JUNHYEOK LEE on 8/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxNimble
import RealmSwift

@testable import HomeData
@testable import BaseData
@testable import BaseDomain

final class HomeBookmarkRepositoryTest: XCTestCase {
    
    var schedular: TestScheduler!
    var disposeBag: DisposeBag!
    var bookmarkStorage: BookmarkStorage!
    var bookmarkRepository: BookmarkRepository!

    override func setUpWithError() throws {
        schedular = TestScheduler(initialClock: 1000)
        disposeBag = DisposeBag()
        
        let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        let realm = try! Realm(configuration: configuration)
        bookmarkStorage = DefaultBookmarkStorage(testRealm: realm)
        bookmarkRepository = DefaultBookmarkRepository()
    }

    override func tearDownWithError() throws {
        schedular = nil
        disposeBag = nil
        
        bookmarkStorage = nil
        bookmarkRepository = nil
    }
    
    func test_savePillSSeq() {
        // given
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
        
        // when
        bookmarkRepository.savePill(pillInfo: pillInfo)
            .subscribe(onSuccess: { result in
                // then
                XCTAssertEqual(result, [123])
            })
            .disposed(by: disposeBag)
    }
    
    func test_ExecutePillSeq() {
        bookmarkRepository.executePillSeqs()
            .subscribe(onSuccess: { result in
                // then
                XCTAssertEqual(result, [])
            })
            .disposed(by: disposeBag)
    }
    
    func test_DeletePill() {
        // given
        let medicineSeq = 123
        
        // when
        bookmarkRepository.deletePill(medicineSeq: medicineSeq)
            .subscribe(onSuccess: { result in
                // then
                XCTAssertEqual(result, [])
            })
            .disposed(by: disposeBag)
    }
    
    func test_DeleteAll() {
        // when
        bookmarkRepository.deleteAll()
            .subscribe(onSuccess: {
                // then
            })
            .disposed(by: disposeBag)
    }
}
