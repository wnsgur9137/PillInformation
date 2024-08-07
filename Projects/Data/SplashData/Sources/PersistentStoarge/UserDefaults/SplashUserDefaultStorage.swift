//
//  SplashUserDefaultStorage.swift
//  SplashData
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseData

public final class SplashUserDefaultStorage {
    
    private let userDefault: UserDefaults
    
    public init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func isShownOnbarding() -> Single<Bool> {
        let key = UserDefaultKey.isShownOnboarding.rawValue
        return .create { single in
            let isShown = self.userDefault.bool(forKey: key)
            single(.success(isShown))
            return Disposables.create()
        }
    }
}
