//
//  RecentKeywordObject.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

final class RecentKeywordObject: Object {
    @Persisted(primaryKey: true) public var keyword: String
    
    public convenience init(keyword: String) {
        self.init()
        self.keyword = keyword
    }
}
