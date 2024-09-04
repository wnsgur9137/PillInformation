//
//  SearchTests.swift
//  SearchTests
//
//  Created by JunHyoek Lee on 9/4/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxNimble
import RxSwift
import RxCocoa
import RxTest
import RealmSwift

@testable import NetworkInfra
@testable import SearchData
@testable import SearchDomain
@testable import SearchPresentation

final class SearchTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: KeywordUseCase!
        var reactor: SearchReactor!
        
        func test_showSearchResultViewController(_: String) { }
        func test_showSearchShapeViewController() { }
        
        describe("📦 Create SerachReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let network = NetworkManager(withTest: true, withFail: false, baseURL: "")
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let storage = DefaultKeywordStorage(testRealm: realm)
                let repository = DefaultKeywordRepository(
                    networkManager: network,
                    keywordStorage: storage
                )
                useCase = DefaultKeywordUseCase(keywordRepository: repository)
                let flowAction = SearchFlowAction(
                    showSearchResultViewController: test_showSearchResultViewController,
                    showSearchShapeViewController: test_showSearchShapeViewController
                )
                reactor = SearchReactor(
                    with: useCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
            }
            
            context("🟢 ViewDidLoad") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { SearchReactor.Action.loadRecommendKeyword }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recommend keyword count") {
                    let observer = scheduler.createObserver(Void.self)
                    
                    reactor.state
                        .map { $0.reloadCollectionViewData }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Void>>] = [
                        .next(10, ())
                    ]
                    
                    scheduler.start()
                    
//                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 ViewWillAppear") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ())
                    ])
                    observable
                        .map { SearchReactor.Action.loadRecentKeyword }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keyword") {
                    let observer = scheduler.createObserver([String].self)
                    
                    let fetchObservable = scheduler.createColdObservable([
                        .next(30, ())
                    ])
                    fetchObservable
                        .flatMapLatest {
                            return useCase.fetchRecentKeywords()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<[String]>>] = [
                        .next(30, [])
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Save recent keyword") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, "TEST1"),
                        .next(20, "TEST2"),
                        .next(30, "TEST3"),
                        .next(40, "TEST4")
                    ])
                    
                    observable
                        .flatMapLatest { keyword in
                            return useCase.saveRecentKeyword(keyword)
                        }
                        .subscribe(onError: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keyword") {
                    let observer = scheduler.createObserver([String].self)
                    
                    let fetchObservable = scheduler.createColdObservable([
                        .next(5, ()),
                        .next(15, ()),
                        .next(25, ()),
                        .next(35, ()),
                        .next(45, ())
                    ])
                    fetchObservable
                        .flatMapLatest {
                            return useCase.fetchRecentKeywords()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<[String]>>] = [
                        .next(5, []),
                        .next(15, ["TEST1"]),
                        .next(25, ["TEST1", "TEST2"]),
                        .next(35, ["TEST1", "TEST2", "TEST3"]),
                        .next(45, ["TEST1", "TEST2", "TEST3", "TEST4"]),
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Delete recent keyword") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, "TEST1"),
                        .next(20, "TEST2"),
                        .next(30, "TEST3"),
                        .next(40, "TEST4")
                    ])
                    
                    observable
                        .flatMapLatest { keyword in
                            return useCase.saveRecentKeyword(keyword)
                        }
                        .subscribe(onError: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    let deleteObservable = scheduler.createColdObservable([
                        .next(50, IndexPath(row: 0, section: 0)),
                        .next(100, IndexPath(row: 0, section: 0))
                    ])
                    deleteObservable
                        .map { indexPath in SearchReactor.Action.didSelectTableViewDeleteButton(indexPath)}
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keyword") {
                    let observer = scheduler.createObserver([String].self)
                    
                    let fetchObservable = scheduler.createColdObservable([
                        .next(5, ()),
                        .next(45, ()),
                        .next(70, ()),
                        .next(120, ())
                    ])
                    fetchObservable
                        .flatMapLatest {
                            return useCase.fetchRecentKeywords()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<[String]>>] = [
                        .next(5, []),
                        .next(45, ["TEST1", "TEST2", "TEST3", "TEST4"]),
                        .next(70, ["TEST2", "TEST3", "TEST4"]),
                        .next(120, ["TEST3", "TEST4"])
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Delete all recent keyword") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, "TEST1"),
                        .next(20, "TEST2"),
                        .next(30, "TEST3"),
                        .next(40, "TEST4")
                    ])
                    
                    observable
                        .flatMapLatest { keyword in
                            return useCase.saveRecentKeyword(keyword)
                        }
                        .subscribe(onError: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    let deleteObservable = scheduler.createColdObservable([
                        .next(50, ())
                    ])
                    deleteObservable
                        .map { SearchReactor.Action.deleteAllRecentKeywords }
                        .subscribe(onError: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load recent keyword") {
                    let observer = scheduler.createObserver([String].self)
                    
                    let fetchObservable = scheduler.createColdObservable([
                        .next(5, ()),
                        .next(45, ()),
                        .next(65, ()),
                    ])
                    fetchObservable
                        .flatMapLatest {
                            return useCase.fetchRecentKeywords()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<[String]>>] = [
                        .next(5, []),
                        .next(45, ["TEST1", "TEST2", "TEST3", "TEST4"]),
                        .next(65, [])
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // sepc
}
