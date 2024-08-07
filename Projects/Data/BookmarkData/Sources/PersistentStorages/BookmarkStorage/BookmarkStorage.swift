//
//  BookmarkStorage.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol BookmarkStorage {
    func getPillSeqs() -> Single<[Int]>
    func getPill(medicineSeq: Int) -> Single<PillInfoResponseDTO>
    func getPills() -> Single<[PillInfoResponseDTO]>
    
    func save(response: PillInfoResponseDTO) -> Single<[Int]>
    
    func delete(medicineSeq: Int) -> Single<[Int]>
    func deleteAll() -> Single<Void>
}
