//
//  UserDefaultService.swift
//  Service
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public final class UserDefaultService {
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
        return self.defaults.value(forKey: key.key) as? T
    }
    
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
        self.defaults.set(value, forKey: key.key)
    }

    func remove<T>(forKey key: UserDefaultsKey<T>) {
        return self.defaults.removeObject(forKey: key.key)
    }

    func removeAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
