//
//  DefaultHomeRepository.swift
//  HomeData
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import HomeDomain
import NetworkInfra

public final class DefaultHomeRepository: HomeRepository {
    
    private let network: NetworkInfra
    
    public func executeNotices() -> [HomeDomain.Notice] {
        
    }
}
