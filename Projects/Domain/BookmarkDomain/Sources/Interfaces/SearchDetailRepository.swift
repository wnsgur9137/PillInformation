//
//  SearchDetailRepository.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol SearchDetailRepository {
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?>
}
