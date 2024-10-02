//
//  TimerDetailTests.swift
//  AlarmTests
//
//  Created by JunHyoek Lee on 8/29/24.
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
import ReactorKit

@testable import AlarmData
@testable import AlarmDomain
@testable import AlarmPresentation

extension TimerModel: Equatable {
    public static func == (lhs: TimerModel, rhs: TimerModel) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.duration == rhs.duration &&
            lhs.startedDate == rhs.startedDate &&
            lhs.isStarted == rhs.isStarted
        )
        
    }
}

final class TimerDetailTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: TimerUseCase!
        var reactor: TimerDetailReactor!
        
        describe("📦 Create TimerDetailReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let timerStorage: TimerStorage = DefaultTimerStorage(testRealm: realm)
                let timerRepository: TimerRepository = DefaultTimerRepository(timerStorage: timerStorage)
                useCase = DefaultTimerUseCase(with: timerRepository)
                let flowAction = TimerDetailFlowAction()
                reactor = TimerDetailReactor(
                    with: useCase,
                    flowAction: flowAction,
                    timerModel: nil
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
            }
            
            context("🟢 Tapped operation button") {
                let expectedTitle: String = "TestTimer"
                let expectedDuration: TimeInterval = 1000
                
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ()),
                        .next(30, ())
                    ])
                    observable
                        .map { TimerDetailReactor.Action.didTapOperationButton((
                            title: expectedTitle,
                            duration: expectedDuration
                        ))}
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load isStarted") {
                    let isStartedObserver = scheduler.createObserver(Bool.self)
                    let timerDataObserver = scheduler.createObserver(TimerModel.self)
                    
                    reactor.state
                        .map { $0.isStarted }
                        .asObservable()
                        .skip(1)
                        .subscribe(isStartedObserver)
                        .disposed(by: disposeBag)
                    
                    reactor.state
                        .filter { $0.timerData.isNotNull }
                        .map { $0.timerData! }
                        .asObservable()
                        .skip(1)
                        .subscribe(timerDataObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedIsStartedEvents: [Recorded<Event<Bool>>] = [
                        .next(10, false),
                        .next(30, true)
                    ]
                    
                    expect(isStartedObserver.events).to(equal(expectedIsStartedEvents))
                    
                    guard let timerDataResult = timerDataObserver.events.first?.value else {
                        XCTFail("No timer data .next event found")
                        return
                    }
                    switch timerDataResult {
                    case let .next(timerModel):
                        expect(timerModel).toNot(beNil())
                        expect(timerModel.title).to(equal(expectedTitle))
                        expect(timerModel.duration).to(equal(expectedDuration))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
        } // describe (timerModel nil)
        
        describe("📦 Create TimerDetailReactor(has timerModel)") {
            let expectedTimerModel: TimerModel = .init(
                id: 1,
                title: "TestTimer",
                duration: 1000,
                startedDate: Date(),
                isStarted: false
            )
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let timerStorage: TimerStorage = DefaultTimerStorage(testRealm: realm)
                let timerRepository: TimerRepository = DefaultTimerRepository(timerStorage: timerStorage)
                useCase = DefaultTimerUseCase(with: timerRepository)
                let flowAction = TimerDetailFlowAction()
                reactor = TimerDetailReactor(
                    with: useCase,
                    flowAction: flowAction,
                    timerModel: expectedTimerModel
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
            }
            
            context("🟢 viewDidLoad") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    observable
                        .map { TimerDetailReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load timer model") {
                    let observer = scheduler.createObserver(TimerModel.self)
                    
                    reactor.state
                        .filter { $0.timerData.isNotNull }
                        .map { $0.timerData! }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<TimerModel>>] = [
                        .next(10, expectedTimerModel)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe (has timer model)
    } // spec
}
