//
//  Identifier.swift
//  Common
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

private protocol ReusableProtocol: AnyObject {
    static var identifier: String { get }
}

extension UIViewController: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

//extension UITableViewCell: ReusableProtocol {
//    public static var identifier: String {
//        return String(describing: self)
//    }
//}
//
//extension UICollectionViewCell: ReusableProtocol {
//    public static var identifier: String {
//        return String(describing: self)
//    }
//}
