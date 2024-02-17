//
//  HomeUseCase.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public final class HomeUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(with repository: HomeRepository) {
        self.homeRepository = repository
    }
}

public extension HomeUseCase {
    func getNotice() -> Single<String> {
        return .just("Notices")
    }
}
