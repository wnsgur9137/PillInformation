//
//  NoticeUseCase.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol NoticeUseCase {
    func executeNotice() -> Single<[NoticeModel]>
}
