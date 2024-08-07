//
//  HomeRepository.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol NoticeRepository {
    func executeNotices() -> Single<[Notice]>
}
