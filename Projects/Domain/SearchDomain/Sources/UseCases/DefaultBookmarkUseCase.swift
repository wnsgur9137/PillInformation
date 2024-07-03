//
//  DefaultBookmarkUseCase.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchPresentation

public final class DefaultBookmarkUseCase: BookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
}

extension DefaultBookmarkUseCase {
    public func fetchPillSeqs() -> Single<[Int]> {
        return bookmarkRepository.executePillSeqs()
    }
    
    public func savePill(pillInfo: PillInfoModel) -> Single<[Int]> {
        let pillInfo = PillInfo(pillInfoModel: pillInfo)
        return bookmarkRepository.savePill(pillInfo: pillInfo)
    }
    
    public func deletePill(medicineSeq: Int) -> Single<[Int]> {
        return bookmarkRepository.deletePill(medicineSeq: medicineSeq)
    }
    
    public func deleteAll() -> Single<Void> {
        return bookmarkRepository.deleteAll()
    }
}
