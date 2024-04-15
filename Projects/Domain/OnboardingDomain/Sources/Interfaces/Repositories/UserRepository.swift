//
//  UserRepository.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserOnboardingRepository {
    func getUser(userID: Int) -> Single<User>
    func signinUser(identifier: String) -> Single<User>
    func postUser(_ user: User) -> Single<User>
    
    func fetchUserStorage(userID: Int) -> Single<User>
    func saveStorage(_ user: User) -> Single<User>
    func updateStorage(_ user: User) -> Single<User>
    
    func saveEmailToKeychain(_ email: String) -> Single<Void>
    func getEmailToKeychain() -> Single<String>
    func updateEmailToKeychain(_ email: String) -> Single<String>
    func deleteEmailFromKeychain() -> Single<Void>
}
