//
//  HomeUseCase.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol NoticeUseCase {
    func executeNotice() -> Single<[Notice]>
}

public final class DefaultNoticeUseCase: NoticeUseCase {
    
    private let noticeRepository: NoticeRepository
    
    public init(with repository: NoticeRepository) {
        self.noticeRepository = repository
    }
}

public extension DefaultNoticeUseCase {
    func executeNotice() -> Single<[Notice]> {
        return noticeRepository.executeNotices()
    }
}
