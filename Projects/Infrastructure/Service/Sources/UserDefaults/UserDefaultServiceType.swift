//
//  UserDefaultServiceType.swift
//  Service
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public protocol UserDefaultServiceType {
    func value<T>(forKey key: UserDefaultsKey<T>) -> T?
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
    func remove<T>(forKey key: UserDefaultsKey<T>)
}
