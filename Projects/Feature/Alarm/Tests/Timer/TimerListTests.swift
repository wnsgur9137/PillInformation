//
//  TimerListTests.swift
//  AlarmTests
//
//  Created by JunHyoek Lee on 8/30/24.
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

@testable import AlarmData
@testable import AlarmDomain
@testable import AlarmPresentation

final class TimerListTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: TimerUseCase!
        var reactor: TimerReactor!
        
        func test_showTimerDetailViewController(_: TimerModel?) { }
        
        describe("📦 Create TimerReactor") {
            let expectedTimerModels: [TimerModel] = [
                .init(
                    id: 0,
                    title: "TestTimer0",
                    duration: 500,
                    startedDate: Date(),
                    isStarted: true
                ),
                .init(
                    id: 1,
                    title: "TestTimer1",
                    duration: 1000,
                    startedDate: Date(),
                    isStarted: true
                ),
                .init(
                    id: 2,
                    title: "TestTimer2",
                    duration: 1500,
                    startedDate: Date(),
                    isStarted: false
                )
            ]
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let timerStorage: TimerStorage = DefaultTimerStorage(testRealm: realm)
                let timerRepository: TimerRepository = DefaultTimerRepository(timerStorage: timerStorage)
                useCase = DefaultTimerUseCase(with: timerRepository)
                let flowAction = TimerFlowAction(showTimerDetailViewController: test_showTimerDetailViewController)
                reactor = TimerReactor(
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
            
            context("🟢 viewWillAppear") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ()),
                        .next(100, ())
                    ])
                    observable
                        .map { TimerReactor.Action.viewWillAppear }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let saveObservable = scheduler.createColdObservable([
                        .next(50, ()),
                    ])
                    saveObservable
                        .subscribe(onNext: {
                            expectedTimerModels.forEach { timerModel in
                                useCase.save(timerModel)
                                    .subscribe(onFailure: { error in
                                        XCTFail("Error: \(error)")
                                    })
                                    .disposed(by: disposeBag)
                            }
                        })
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load timer count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.state
                        .map { $0.timerCellCount }
                        .asObservable()
                        .skip(1)
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(10, 0),
                        .next(100, 3)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 deleteRow") {
                beforeEach {
                    let saveObservable = scheduler.createColdObservable([
                        .next(10, ()),
                    ])
                    saveObservable
                        .subscribe(onNext: {
                            expectedTimerModels.forEach { timerModel in
                                useCase.save(timerModel)
                                    .subscribe(onFailure: { error in
                                        XCTFail("Error: \(error)")
                                    })
                                    .disposed(by: disposeBag)
                            }
                        })
                        .disposed(by: disposeBag)
                    
                    let loadObservable = scheduler.createColdObservable([
                        .next(50, ())
                    ])
                    loadObservable
                        .map { TimerReactor.Action.viewWillAppear }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let deleteObservable = scheduler.createColdObservable([
                        .next(100, IndexPath(row: 1, section: 0)),
                        .next(120, IndexPath(row: 0, section: 1)),
                        .next(200, IndexPath(row: 0, section: 0))
                    ])
                    deleteObservable
                        .map { indexPath in TimerReactor.Action.deleteRow(indexPath) }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load timer count") {
                    let observable = scheduler.createColdObservable([
                        .next(0, ()), // 0
                        .next(60, ()), // 3
                        .next(90, ()), // 3
                        .next(110, ()), // 2
                        .next(115, ()), // 2
                        .next(130, ()), // 1
                        .next(195, ()), // 1
                        .next(210, ()) // 0
                    ])
                    
                    let observer = scheduler.createObserver(Int.self)
                    
                    observable
                        .flatMapLatest {
                            return useCase.executeCount()
                        }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(0, 0),
                        .next(60, 3),
                        .next(90, 3),
                        .next(110, 2),
                        .next(115, 2),
                        .next(130, 1),
                        .next(195, 1),
                        .next(210, 0)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // spec
}
