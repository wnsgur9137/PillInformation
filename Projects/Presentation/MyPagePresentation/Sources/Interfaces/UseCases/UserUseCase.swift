//
//  UserUseCase.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol UserUseCase {
    func executeUser(userID: Int) -> Single<UserModel>
    func update(_ userModel: UserModel) -> Single<UserModel>
    func delete(userID: Int) -> Single<Void>
    
    func fetchUserStorage(userID: Int) -> Single<UserModel>
    func fetchFirstUserStorage() -> Single<UserModel>
    func deleteStorage(userID: Int) -> Single<Void>
}
