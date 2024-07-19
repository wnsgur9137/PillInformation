//
//  SplashUserDefaultStorage.swift
//  SplashData
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public final class SplashUserDefaultStorage {
    
    private let userDefault = UserDefaults.standard
    
    private let isShownOnboardingKey: String = "isShownOnboarding"
    
    public init() {
        
    }
    
    func setIsShownOnboarding(_ isShown: Bool) -> Single<Bool> {
        let key = isShownOnboardingKey
        userDefault.set(isShown, forKey: key)
        return .create { single in
            let isShwon = self.userDefault.bool(forKey: key)
            single(.success(isShown))
            return Disposables.create()
        }
    }
    
    func isShownOnbarding() -> Single<Bool> {
        let key = isShownOnboardingKey
        return .create { single in
            let isShown = self.userDefault.bool(forKey: key)
            single(.success(isShown))
            return Disposables.create()
        }
    }
}
