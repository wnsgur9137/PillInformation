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
    func getUserResponse() -> Single<UserDTO>
    func save(response: UserDTO) -> Single<Void>
}
