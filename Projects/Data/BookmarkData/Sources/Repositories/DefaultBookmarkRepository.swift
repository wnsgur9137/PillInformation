//
//  DefaultBookmarkRepository.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BookmarkDomain
import BaseDomain

public final class DefaultBookmarkRepository: BookmarkDomain.BookmarkRepository {
    private let bookmarkStorage: BookmarkStorage
    
    public init(bookmarkStorage: BookmarkStorage = DefaultBookmarkStorage()) {
        self.bookmarkStorage = bookmarkStorage
    }
}

extension DefaultBookmarkRepository {
    public func executePillSeqs() -> Single<[Int]> {
        return bookmarkStorage.getPillSeqs()
    }
    
    public func executePills() -> Single<[PillInfo]> {
        return bookmarkStorage.getPills().map { $0.map { $0.toDomain() } }
    }
    
    public func savePill(pillInfo: PillInfo) -> Single<[Int]> {
        let pillInfoDTO = PillInfoResponseDTO(pillInfo: pillInfo)
        return bookmarkStorage.save(response: pillInfoDTO)
    }
    
    public func deletePill(medicineSeq: Int) -> Single<[Int]> {
        return bookmarkStorage.delete(medicineSeq: medicineSeq)
    }
    
    public func deleteAll() -> Single<Void> {
        return bookmarkStorage.deleteAll()
    }
}
