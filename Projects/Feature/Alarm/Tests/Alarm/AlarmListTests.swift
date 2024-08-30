//
//  AlarmListTests.swift
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

final class AlarmListTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: AlarmUseCase!
        var reactor: AlarmReactor!
        var realm: Realm!
        
        let expectedAlarmData: [AlarmModel] = [
            AlarmModel(id: 0, title: "Test1", alarmTime: Date(), week: WeekModel(), isActive: true),
            AlarmModel(id: 1, title: "Test2", alarmTime: Date(), week: WeekModel(), isActive: true),
            AlarmModel(id: 2, title: "Test3", alarmTime: Date(), week: WeekModel(), isActive: true),
            AlarmModel(id: 3, title: "Test4", alarmTime: Date(), week: WeekModel(), isActive: false),
            AlarmModel(id: 4, title: "Test5", alarmTime: Date(), week: WeekModel(), isActive: false),
        ]
        
        func showAlarmDetailViewController(_: AlarmModel?) { }
        
        describe("") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                realm = try! Realm(configuration: configuration)
                let alarmStorage = DefaultAlarmStorage(testRealm: realm)
                let alarmRepository = DefaultAlarmRepository(alarmStorage: alarmStorage)
                useCase = DefaultAlarmUseCase(alarmRepository: alarmRepository)
                let flowAction = AlarmFlowAction(showAlarmDetailViewController: showAlarmDetailViewController)
                reactor = AlarmReactor(
                    with: useCase,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                useCase = nil
                reactor = nil
                realm = nil
            }
            
            context("🟢 Save mock data") {
                beforeEach {
                    let observable = scheduler.createHotObservable([
                        .next(0, ())
                    ])
                    observable.subscribe(onNext: {
                        expectedAlarmData.forEach {
                            useCase.save($0)
                                .subscribe()
                                .disposed(by: disposeBag)
                        }
                    })
                    .disposed(by: disposeBag)
                }
                
                it("✅ Load mock data") {
                    let observer = scheduler.createObserver([AlarmModel].self)
                    
                    scheduler.start()
                    
                    useCase.executeAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<[AlarmModel]>>] = [
                        .next(0, expectedAlarmData),
                        .completed(0)
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 ViewWillAppear") {
                beforeEach {
                    let saveObservable = scheduler.createHotObservable([
                        .next(0, ())
                    ])
                    saveObservable.subscribe(onNext: {
                        expectedAlarmData.forEach {
                            useCase.save($0)
                                .subscribe()
                                .disposed(by: disposeBag)
                        }
                    })
                    .disposed(by: disposeBag)
                    
                    let observable = scheduler.createColdObservable([
                        .next(100, ())
                    ])
                    observable
                        .map { AlarmReactor.Action.viewWillAppear }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load alarm cell count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    reactor.pulse(\.$alarmCellCount)
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(100, expectedAlarmData.count)
                    ]
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 DeleteRow") {
                beforeEach {
                    let saveObservable = scheduler.createHotObservable([
                        .next(0, ())
                    ])
                    saveObservable.subscribe(onNext: {
                        expectedAlarmData.forEach {
                            useCase.save($0)
                                .subscribe()
                                .disposed(by: disposeBag)
                        }
                    })
                    .disposed(by: disposeBag)
                    
                    let executeObject = scheduler.createHotObservable([
                        .next(10, ())
                    ])
                    executeObject
                        .map { AlarmReactor.Action.viewWillAppear }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    
                    let deleteObservable = scheduler.createColdObservable([
                        .next(20, (IndexPath(row: 0, section: 0)))
                    ])
                    deleteObservable
                        .map { indexPath in AlarmReactor.Action.delete(indexPath) }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load alarms") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    let executeSubject = PublishSubject<()>()
                    
                    executeSubject
                        .flatMapLatest {
                            return useCase.executeAll()
                        }
                        .asObservable()
                        .map { return $0.count }
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.scheduleAt(50) {
                        executeSubject.onNext(())
                    }
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<Int>>] = [
                        .next(50, 4)
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // spec
}
