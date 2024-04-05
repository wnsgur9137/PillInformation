//
//  DefaultNoticeUseCase.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import HomePresentation

public final class DefaultNoticeUseCase: NoticeUseCase {
    
    private let noticeRepository: NoticeRepository
    
    public init(with repository: NoticeRepository) {
        self.noticeRepository = repository
    }
}

extension DefaultNoticeUseCase {
    public func executeNotice() -> Single<[NoticeModel]> {
        return noticeRepository.executeNotices().map {
            $0.map { $0.toModel() }
        }
    }
}
