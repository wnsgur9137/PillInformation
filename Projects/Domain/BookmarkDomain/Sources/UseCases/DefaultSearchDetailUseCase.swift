//
//  DefaultSearchDetailUseCase.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation
import BaseDomain

public final class DefaultSearchDetailUseCase: SearchDetailUseCase {
    
    private let searchDetailRepository: SearchDetailRepository
    private let bookmarkRepository: BookmarkRepository
    private let disposeBag = DisposeBag()
    
    public init(searchDetailRepository: SearchDetailRepository,
                bookmarkRepository: BookmarkRepository) {
        self.searchDetailRepository = searchDetailRepository
        self.bookmarkRepository = bookmarkRepository
    }
    
}

extension DefaultSearchDetailUseCase {
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?> {
        return searchDetailRepository.executePillDescription(medicineSeq).map { $0?.toModel() }
    }
    
    public func fetchBookmark(medicineSeq: Int) -> Single<Bool> {
        return bookmarkRepository.executePillSeqs()
            .map { $0.contains(medicineSeq) }
    }
    
    public func saveBookmark(pillInfo: PillInfoModel) -> Single<Bool> {
        let pillInfo = PillInfo.makePillInfo(pillInfo)
        return bookmarkRepository.savePill(pillInfo: pillInfo)
            .map { $0.contains(pillInfo.medicineSeq) }
    }
    
    public func deleteBookmark(medicineSeq: Int) -> Single<Bool> {
        return bookmarkRepository.deletePill(medicineSeq: medicineSeq)
            .map { $0.contains(medicineSeq) }
    }
    
    public func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel> {
        var histories = searchDetailRepository.loadHitHistories()
        guard histories.contains(medicineSeq) == false else { return .error(SearchDetailUseCaseError.alreadyHits) }
        histories.append(medicineSeq)
        searchDetailRepository.saveHitHistories(histories)
        return searchDetailRepository.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName).map { $0.toModel() }
    }
}
