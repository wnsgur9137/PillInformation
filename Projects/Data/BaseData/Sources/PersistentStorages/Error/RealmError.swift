//
//  RealmError.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public enum RealmError: Error {
    case save
    case fetch
    case update
    case delete
}
