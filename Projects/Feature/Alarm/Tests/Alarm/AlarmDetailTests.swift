//
//  AlarmDetailTests.swift
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

@testable import AlarmData
@testable import AlarmDomain
@testable import AlarmPresentation

extension AlarmModel: Equatable {
    public static func == (lhs: AlarmModel, rhs: AlarmModel) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.alarmTime == rhs.alarmTime &&
            lhs.week == rhs.week &&
            lhs.isActive == rhs.isActive
        )
    }
}

final class AlarmDetailTests: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var useCase: AlarmUseCase!
        var reactor: AlarmDetailReactor!
        var realm: Realm!
        
        func test(_: Bool) { }
        
        describe("📦 Create AlarmDetailReactor(nil)") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                realm = try! Realm(configuration: configuration)
                let alarmStorage: AlarmStorage = DefaultAlarmStorage(testRealm: realm)
                let alarmRepository: AlarmRepository = DefaultAlarmRepository(alarmStorage: alarmStorage)
                useCase = DefaultAlarmUseCase(alarmRepository: alarmRepository)
                let flowAction = AlarmDetailFlowAction(popViewController: test)
                reactor = AlarmDetailReactor(
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
                    let viewDidLoadObservable = scheduler.createColdObservable([
                        .next(10, ())
                    ])
                    viewDidLoadObservable
                        .map { AlarmDetailReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Load AlarmModel") {
                    let observer = scheduler.createObserver(AlarmModel?.self)
                    
                    reactor.state
                        .map { $0.alarmData }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<AlarmModel?>>] = [
                        .next(10, nil)
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped SundayButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapSundayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(sunday: true)),
                        .next(40, WeekModel(sunday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped MondayButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapMondayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(monday: true)),
                        .next(40, WeekModel(monday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped TuesdayButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapTuesdayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(tuesday: true)),
                        .next(40, WeekModel(tuesday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped WednesButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapWednesdayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(wednesday: true)),
                        .next(40, WeekModel(wednesday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped ThursButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapThurdayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(thursday: true)),
                        .next(40, WeekModel(thursday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped FriButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapFridayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(friday: true)),
                        .next(40, WeekModel(friday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped SaturButton") {
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(20, ()),
                        .next(40, ())
                    ])
                    observable
                        .map { AlarmDetailReactor.Action.didTapSaturdayButton }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Updates WeekModel correctly") {
                    let observer = scheduler.createObserver(WeekModel?.self)
                    
                    reactor.state
                        .map { $0.week }
                        .skip(1)
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<WeekModel?>>] = [
                        .next(20, WeekModel(saturday: true)),
                        .next(40, WeekModel(saturday: false))
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
            
            context("🟢 Tapped SaveButton") {
                let expectedTitle = "TestTitle11"
                
                beforeEach {
                    let observable = scheduler.createColdObservable([
                        .next(0, ())
                    ])
                    
                    observable
                        .map { AlarmDetailReactor.Action.didTapSaveButton((
                            time: Date(),
                            title: expectedTitle,
                            isSelectedDays: (
                                sunday: true,
                                monday: false,
                                tuesday: false,
                                wednesday: false,
                                thursday: false,
                                friday: false,
                                saturday: false
                            )
                        ))}
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                it("✅ Save Alarm") {
                    let observer = scheduler.createObserver([AlarmModel].self)
                    
                    useCase.executeAll()
                        .asObservable()
                        .skip(1)
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    guard let result = observer.events.first?.value else {
                        XCTFail("No .next event found")
                        return
                    }
                    switch result {
                    case let .next(alarmModels):
                        expect(alarmModels.map { $0.title }).to(contain(expectedTitle))
                    case let .error(error):
                        XCTFail("Error: \(error)")
                    default: return
                    }
                }
            }
            
        } // describe
        
        describe("📦 Create AlarmDetailReactor(has Data)") {
            
            let expectedAlarmModel: AlarmModel = .init(
                id: 3,
                title: "TestTitle",
                alarmTime: Date(),
                week: WeekModel(
                    sunday: true,
                    monday: true,
                    tuesday: true,
                    wednesday: false,
                    thursday: false,
                    friday: false,
                    saturday: false
                ),
                isActive: true
            )
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                
                let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
                let realm = try! Realm(configuration: configuration)
                let alarmStorage: AlarmStorage = DefaultAlarmStorage(testRealm: realm)
                let alarmRepository: AlarmRepository = DefaultAlarmRepository(alarmStorage: alarmStorage)
                let alarmUseCase: AlarmUseCase = DefaultAlarmUseCase(alarmRepository: alarmRepository)
                let flowAction = AlarmDetailFlowAction(popViewController: test)
                reactor = AlarmDetailReactor(
                    with: alarmUseCase,
                    alarmModel: expectedAlarmModel,
                    flowAction: flowAction
                )
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
            }
            
            context("🟢 ViewDidLoad") {
                
                beforeEach {
                    let viewDidLoadObservable = scheduler.createColdObservable([.next(10, ())])
                    viewDidLoadObservable
                        .map { AlarmDetailReactor.Action.viewDidLoad }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                    scheduler.start()
                }
                
                it("✅ Load AlarmModel") {
                    let observer = scheduler.createObserver(AlarmModel?.self)
                    
                    reactor.state
                        .map { $0.alarmData }
                        .asObservable()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    let expectedEvents: [Recorded<Event<AlarmModel?>>] = [
                        .next(10, expectedAlarmModel)
                    ]
                    
                    expect(observer.events).to(equal(expectedEvents))
                }
            }
        } // describe
    } // spec
}
