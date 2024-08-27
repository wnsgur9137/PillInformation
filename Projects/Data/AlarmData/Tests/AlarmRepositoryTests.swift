//
//  AlarmRepositoryTests.swift
//  AlarmDataTests
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

@testable import AlarmData
@testable import AlarmDomain

final class AlarmRepositoryTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var alarmRepository: AlarmRepository!
        
        describe("📦 Create AlarmRepository") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let alarmStorage = DefaultAlarmStorage(testRealm: realm)
                alarmRepository = DefaultAlarmRepository(alarmStorage: alarmStorage)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                alarmRepository = nil
            }
            
            context("🟢 Save Alarm") {
                
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
                
                let observer = scheduler.createObserver(Alarm.self)
                
                let expectedAlarm = Alarm(id: 10, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(sunday: true, tuesday: true, friday: true), isActive: true)
                
                alarmRepository.save(expectedAlarm)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                
                guard let result = observer.events.first?.value else {
                    XCTFail("No .next event found")
                    return
                }
                switch result {
                case let .next(alarm):
                    expect(alarm.id).to(equal(expectedAlarm.id))
                    expect(alarm.title).to(equal(expectedAlarm.title))
                    expect(alarm.alarmTime).to(equal(expectedAlarm.alarmTime))
                    expect(alarm.isActive).to(equal(expectedAlarm.isActive))
                case let .error(error):
                    XCTFail("Error: \(error)")
                default: return
                }
            }
            
            context("🟢 Fetch Alarm") {
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
            }
            
            context("🟢 Fetch All Alarm") {
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
                
                it("✅ Load Alarms") {
                    let observer = scheduler.createObserver([Alarm].self)
                    
                    // Save 5 expected alarm
                    let expectedCount: Int = 5
                    for id in 1...expectedCount {
                        let expectedAlarm = Alarm(id: id, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(sunday: true, tuesday: true, friday: true), isActive: true)
                        
                        alarmRepository.save(expectedAlarm)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    alarmRepository.fetchAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(alarms):
                        expect(alarms.count).to(equal(expectedCount))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Fetch Alarm Count") {
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
                
                it("✅ Load Alarm Count") {
                    let observer = scheduler.createObserver(Int.self)
                    
                    // Save 5 expected alarm
                    let expectedCount: Int = 5
                    for id in 1...expectedCount {
                        let expectedAlarm = Alarm(id: id, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(sunday: true, tuesday: true, friday: true), isActive: true)
                        
                        alarmRepository.save(expectedAlarm)
                            .subscribe(onFailure: { error in
                                XCTFail("Error: \(error)")
                            })
                            .disposed(by: disposeBag)
                    }
                    
                    alarmRepository.fetchCount()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(count):
                        expect(count).to(equal(expectedCount))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Update Alarm") {
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
                
                it("✅ Load Alarms") {
                    let observer = scheduler.createObserver(Alarm.self)
                    
                    // Save expected alarm
                    let expectedAlarm = Alarm(id: 10, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(sunday: true, tuesday: true, friday: true), isActive: true)
                    
                    alarmRepository.save(expectedAlarm)
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    // Update expected alarm
                    let expectedUpdateAlarm = Alarm(id: 10, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(monday: true), isActive: false)
                    
                    alarmRepository.update(expectedUpdateAlarm)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(alarm):
                        expect(alarm.isActive).to(beFalse())
                        expect(alarm.week.monday).to(beTrue())
                        expect(alarm.week.sunday).to(beFalse())
                        expect(alarm.week.tuesday).to(beFalse())
                        expect(alarm.week.friday).to(beFalse())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete Alarm") {
                beforeEach {
                    let observer = scheduler.createObserver(Void.self)
                    alarmRepository.deleteAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    if case .error(let error) = result {
                        XCTFail("Error: \(error)")
                        return
                    }
                }
                
                it("✅ Delete Alarm") {
                    let observer = scheduler.createObserver([Alarm].self)
                    
                    // Save expected alarm
                    let expectedAlarm = Alarm(id: 10, title: "AlarmTitle", alarmTime: Date(), week: WeekDomain(sunday: true, tuesday: true, friday: true), isActive: true)
                    
                    alarmRepository.save(expectedAlarm)
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    
                    // Fetch all
                    alarmRepository.fetchAll()
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(alarms):
                        expect(alarms.map { $0.id }).toNot(contain(expectedAlarm.id))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
            context("🟢 Delete All Alarm") {
                it("✅ Load Alarms") {
                    let observer = scheduler.createObserver([Alarm].self)
                    alarmRepository.deleteAll()
                        .subscribe(onFailure: { error in
                            XCTFail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                    alarmRepository.fetchAll()
                        .asObservable()
                        .subscribe(onNext: { _ in })
                        .disposed(by: disposeBag)
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(alarms):
                        expect(alarms).to(beEmpty())
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            } // context
        } // describe
    } // spec
}
