//
//  UserStorage.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserStorage {
    func save(response: UserDTO) -> Single<UserDTO>
    func get(userID: Int) -> Single<UserDTO>
    func getFirstUser() -> Single<UserDTO>
    func getTokens(userID: Int) -> Single<(accessToken: String, refreshToken: String)>
    func update(updatedResponse: UserDTO) -> Single<UserDTO>
    func delete(userID: Int) -> Single<Void>
    
    func saveToKeychain(_ email: String) -> Single<Void>
    func getEmailFromKeychain() -> Single<String>
    func updateEmailToKeychain(_ email: String) -> Single<String>
    func deleteEmailFromKeychain() -> Single<Void>
}
