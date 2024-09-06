//
//  SearchUseCase.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchPresentation
import BaseDomain
import BasePresentation

public protocol SearchTabUseCase: SearchUseCase, SearchDetailUseCase { }

public final class DefaultSearchUseCase: SearchTabUseCase {
    
    private let searchRepository: SearchRepository
    private let searchDetailRepository: SearchDetailRepository
    private let bookmarkRepository: BookmarkRepository
    private let disposeBag = DisposeBag()
    
    public init(searchRepository: SearchRepository,
                searchDetailRepository: SearchDetailRepository,
                bookmarkRepository: BookmarkRepository) {
        self.searchRepository = searchRepository
        self.searchDetailRepository = searchDetailRepository
        self.bookmarkRepository = bookmarkRepository
    }
    
    private func executePillHits(_ medicineSeq: Int) -> Single<PillHitsModel> {
        return searchRepository.executePillHits(medicineSeq: medicineSeq).map { $0.toModel() }
    }
    
    private func executePillData(fetchPills: @escaping () -> Single<[PillInfo]>) -> Single<[PillInfoModel]> {
        return .create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            fetchPills()
                .flatMap { pills in
                    Observable.from(pills.map { $0.toModel() })
                        .flatMap { info in
                            self.executePillHits(info.medicineSeq)
                                .map { hits -> PillInfoModel in
                                    var updatedInfo = info
                                    updatedInfo.hits = hits.hits
                                    return updatedInfo
                                }
                                .catchAndReturn(info)
                        }
                        .toArray()
                }
                .subscribe(onSuccess: { updatedInfos in
                    single(.success(updatedInfos))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

extension DefaultSearchUseCase {
    public func executePill(keyword: String) -> Single<[PillInfoModel]> {
        return executePillData { self.searchRepository.executePill(keyword: keyword) }
    }
    
    public func executePill(pillShape: PillShapeModel) -> Single<[PillInfoModel]> {
        let shapeInfo = PillShape.create(model: pillShape)
        return executePillData { self.searchRepository.executePill(shapeInfo: shapeInfo) }
    }
    
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?> {
        return searchRepository.executePillDescription(medicineSeq).map { $0?.toModel() }
    }
    
    public func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel> {
        var histories = searchDetailRepository.loadHitHistories()
        guard histories.contains(medicineSeq) == false else { return .error(SearchDetailUseCaseError.alreadyHits) }
        histories.append(medicineSeq)
        _ = searchDetailRepository.saveHitHistories(histories)
        return searchDetailRepository.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName).map { $0.toModel() }
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
}
