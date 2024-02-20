//
//  HomeUseCase.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol HomeUseCase {
    func executeNotice() -> Single<[Notice]>
}

public final class DefaultHomeUseCase: HomeUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(with repository: HomeRepository) {
        self.homeRepository = repository
    }
}

public extension DefaultHomeUseCase {
    func executeNotice() -> Single<[Notice]> {
        return homeRepository.executeNotices()
    }
}
