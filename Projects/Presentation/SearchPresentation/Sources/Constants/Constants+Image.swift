//
//  Constants+Image.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

extension Constants.SearchResult.Image {
    static let star: UIImage = UIImage(systemName: "star") ?? UIImage()
    static let starFill: UIImage = UIImage(systemName: "star.fill") ?? UIImage()
    static let eye: UIImage = UIImage(systemName: "eye") ?? UIImage()
}

extension Constants.SearchDetail.Image {
    static let eye: UIImage = UIImage(systemName: "eye") ?? UIImage()
}

extension Constants.ImageDetail.Image {
    static let share: UIImage = UIImage(systemName: "square.and.arrow.up") ?? UIImage()
    static let download: UIImage = UIImage(systemName: "square.and.arrow.down") ?? UIImage()
}
