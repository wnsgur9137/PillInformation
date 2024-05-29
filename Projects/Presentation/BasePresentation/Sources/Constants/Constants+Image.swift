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
        public static let magnifyingglass: UIImage = UIImage(systemName: "magnifyingglass") ?? UIImage()
        public static let camera: UIImage = UIImage(systemName: "camera") ?? UIImage()
        public static let pills: UIImage = UIImage(systemName: "pills") ?? UIImage()
        public static let plus: UIImage = UIImage(systemName: "plus") ?? UIImage()
        public static let backward: UIImage = .init(systemName: "chevron.backward") ?? UIImage()
        public static let pasteboard: UIImage = UIImage(systemName: "doc.on.clipboard.fill") ?? UIImage()
    }
}

extension Constants.NavigationView.Image {
    static let titleImage: UIImage = .init(named: "TitleLogo") ?? UIImage()
}
