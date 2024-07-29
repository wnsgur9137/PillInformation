//
//  DefaultBookmarkUseCase.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BookmarkPresentation
import BaseDomain
import BasePresentation

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
    
    public func fetchPills() -> Single<[PillInfoModel]> {
        return bookmarkRepository.executePills().map { $0.map { $0.toModel() } }
    }
    
    public func savePill(pillInfo: PillInfoModel) -> Single<[Int]> {
        let pillInfo = PillInfo.makePillInfo(pillInfo)
        return bookmarkRepository.savePill(pillInfo: pillInfo)
    }
    
    public func deletePill(medicineSeq: Int) -> Single<[Int]> {
        return bookmarkRepository.deletePill(medicineSeq: medicineSeq)
    }
    
    public func deleteAll() -> Single<Void> {
        return bookmarkRepository.deleteAll()
    }
}
