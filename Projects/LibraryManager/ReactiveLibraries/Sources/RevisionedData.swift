//
//  RevisionedData.swift
//  ReactiveLibraries
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit

public struct RevisionedData<T>: Equatable {
    public static func == (lhs: RevisionedData, rhs: RevisionedData) -> Bool {
        return lhs.revision == rhs.revision
    }
    
    public let revision: UInt
    public let data: T?
    
    public init(revision: UInt = 0, _ data: T?) {
        self.revision = revision
        self.data = data
    }
}

extension RevisionedData {
    public func update(_ data: T?) -> RevisionedData {
        return RevisionedData<T>(revision: self.revision + 1, data)
    }
}
