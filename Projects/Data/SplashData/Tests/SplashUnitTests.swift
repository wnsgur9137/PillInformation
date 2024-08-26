//
//  SplashUnitTests.swift
//  SplashDataTests
//
//  Created by JunHyoek Lee on 8/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxNimble
import RealmSwift

@testable import SplashDomain
@testable import SplashData
@testable import BaseData

final class SplashUnitTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    var realm: Realm!
    var userRepository: UserRepository!
    var userSplashRepository: UserSplashRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 1000)
        disposeBag = DisposeBag()
        
        let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        self.realm = try! Realm(configuration: configuration)
        
        let networkManager = test_NetworkManager(withFail: false).networkManager
        
        userRepository = DefaultUserRepository(
            networkManager: networkManager,
            userStorage: DefaultUserStorage()
        )
        
        userSplashRepository = DefaultUserSplashRepository(
            networkManager: networkManager,
            userRepository: userRepository
        )
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        realm = nil
        userRepository = nil
        userSplashRepository = nil
        try super.tearDownWithError()
    }
    
    func test_SaveUser() {
//        let userDTO = UserDTO(
//            id: 0,
//            isAgreeAppPolicy: true,
//            isAgreeAgePolicy: true,
//            isAgreePrivacyPolicy: true,
//            isAgreeDaytimeNoti: true,
//            isAgreeNighttimeNoti: false,
//            accessToken: "accessToken",
//            refreshToken: "refreshToken",
//            social: "apple"
//        )
        
//        self.userRepository.saveStorage(userDTO)
//            .subscribe(onSuccess: { result in
//                print("🚨result: \(result)")
//            }, onFailure: { error in
//                print("🚨error: \(error)")
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func test_FetchUser() {
//        let user = userSplashRepository.fetchUserStorage()
//        XCTAssertNotNil(user)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
