//
//  SearchDetailRepository.swift
//  HomeDomain
//
//  Created by JunHyeok Lee on 7/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol SearchDetailRepository {
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?>
}
