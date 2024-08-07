//
//  UserUseCase.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol UserUseCase {
    func executeUser(userID: Int) -> Single<UserModel>
    func signin(identifier: String, social: String) -> Single<UserModel>
    func post(_ user: UserModel) -> Single<UserModel>
    
    func fetchUserStorage(userID: Int) -> Single<UserModel>
    func saveStorage(_ user: UserModel) -> Single<UserModel>
    func updateStorage(_ user: UserModel) -> Single<UserModel>
    
    func saveEmailToKeychain(_ email: String) -> Single<Void>
    func getEmailToKeychain() -> Single<String>
    func updateEmailToKeychain(_ email: String) -> Single<String>
    func deleteEmailFromKeychain() -> Single<Void>
    
    func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool>
}
