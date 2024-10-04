//
//  Optional+isNull.swift
//  BasePresentation
//
//  Created by JunHyoek Lee on 10/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

// MARK: - Optional
extension Optional {
    @inlinable public var isNull: Bool {
        return self == nil
    }
    
    @inlinable public var isNotNull: Bool {
        return self != nil
    }
}

// MARK: - String
extension Optional where Wrapped == String {
    @inlinable public var isNullAndEmpty: Bool {
        guard let self = self else { return true }
        return self.isEmpty
    }
    
    @inlinable public var isNotNullAndNotEmpty: Bool {
        guard let self = self else { return false }
        return !self.isEmpty
    }
}

// MARK: - Collection
extension Optional where Wrapped: Collection {
    @inlinable public var isNullAndEmpty: Bool {
        guard let self = self else { return true }
        return self.isEmpty
    }
    
    @inlinable public var isNotNullAndNotEmpty: Bool {
        guard let self = self else { return false }
        return !self.isEmpty
    }
}
