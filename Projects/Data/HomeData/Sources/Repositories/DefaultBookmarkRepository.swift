//
//  DefaultBookmarkRepository.swift
//  HomeData
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseData
import BaseDomain
import HomeDomain

public final class DefaultBookmarkRepository: BookmarkRepository {
    private let bookmarkStorage: BookmarkStorage
    
    public init(bookmarkStorage: BookmarkStorage = DefaultBookmarkStorage()) {
        self.bookmarkStorage = bookmarkStorage
    }
}

extension DefaultBookmarkRepository {
    public func executePillSeqs() -> Single<[Int]> {
        return bookmarkStorage.getPillSeqs()
    }
    
    public func savePill(pillInfo: PillInfo) -> Single<[Int]> {
        let pillInfoDTO = PillInfoResponseDTO.create(pillInfo: pillInfo)
        return bookmarkStorage.save(response: pillInfoDTO)
    }
    
    public func deletePill(medicineSeq: Int) -> Single<[Int]> {
        return bookmarkStorage.delete(medicineSeq: medicineSeq)
    }
    
    public func deleteAll() -> Single<Void> {
        return bookmarkStorage.deleteAll()
    }
}
