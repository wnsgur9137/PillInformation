//
//  Constants+Image.swift
//  Common
//
//  Created by JUNHYEOK LEE on 2/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension Constants {
    // MARK: - Image
    public struct Image {
        public static let appLogo: UIImage = UIImage(named: "appLogo") ?? UIImage()
    }
}

extension Constants.NavigationView.Image {
    static let titleImage: UIImage = .init(named: "TitleLogo") ?? UIImage()
    static let backward: UIImage = .init(systemName: "chevron.backward") ?? UIImage()
}
