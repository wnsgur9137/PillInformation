//
//  KeywordRepositoryTests.swift
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

@testable import SearchData
@testable import SearchDomain

final class KeywordRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var keywordRepository: KeywordRepository!
        
        describe("📦 Create KeywordRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let networkManager = test_NetworkManager(withFail: false).networkManager
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let keywordStorage = DefaultKeywordStorage(testRealm: realm)
                keywordRepository = DefaultKeywordRepository(networkManager: networkManager, keywordStorage: keywordStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                keywordRepository = nil
            }
            
            context("🟢 Save recent keyword") {
                beforeEach {
                    keywordRepository.deleteAllRecentKeyword()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keywords") {
                    let observer = scheduler.createObserver([String].self)
                    
                    // Save expected recent keywords
                    let expectedRecentKeywords = ["Test1", "Test2", "Test3", "Test4"]
                    expectedRecentKeywords.forEach { keyword in
                        keywordRepository.setRecentKeyword(keyword)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    keywordRepository.executeRecentKeywords()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next events found")
                        return
                    }
                    switch result {
                    case let .next(keywords):
                        expect(keywords.count).to(equal(expectedRecentKeywords.count))
                        keywords.forEach { keyword in
                            expect(expectedRecentKeywords).to(contain(keyword))
                        }
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete recent keyword") {
                beforeEach {
                    keywordRepository.deleteAllRecentKeyword()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keywords") {
                    let observer = scheduler.createObserver([String].self)
                    
                    // Save expected recent keywords
                    let expectedRecentKeywords = ["Test1", "Test2", "Test3", "Test4"]
                    expectedRecentKeywords.forEach { keyword in
                        keywordRepository.setRecentKeyword(keyword)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    // Delete expected recent keyword
                    let expectedDeleteKeyword = expectedRecentKeywords[0]
                    keywordRepository.deleteRecentKeyword(expectedDeleteKeyword)
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    keywordRepository.executeRecentKeywords()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next events found")
                        return
                    }
                    switch result {
                    case let .next(keywords):
                        expect(keywords).toNot(contain(expectedDeleteKeyword))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete all recenty keywords") {
                beforeEach {
                    keywordRepository.deleteAllRecentKeyword()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keywords") {
                    let observer = scheduler.createObserver([String].self)
                    
                    // Save expected recent keywords
                    let expectedRecentKeywords = ["Test1", "Test2", "Test3", "Test4"]
                    expectedRecentKeywords.forEach { keyword in
                        keywordRepository.setRecentKeyword(keyword)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    // Delete all
                    keywordRepository.deleteAllRecentKeyword()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    keywordRepository.executeRecentKeywords()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next events found")
                        return
                    }
                    switch result {
                    case let .next(keywords):
                        expect(keywords).to(beEmpty())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Execute recommend keywords") {
                it("✅ Load recommend keywords") {
                    let observer = scheduler.createObserver([String].self)
                    
                    keywordRepository.executeRecommendKeywords()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                    }
                }
            }
        } // describe
    } // spec
}
