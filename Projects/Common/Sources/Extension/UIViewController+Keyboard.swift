//
//  UIViewController+Keyboard.swift
//  Common
//
//  Created by JunHyeok Lee on 2/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    public var showKeyboard: Observable<Notification> {
        return NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    }
    
    public var hideKeyboard: Observable<Notification> {
        return NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    }
}

extension UIViewController {
    public func keyboardBackgroundTapGesture(_ view: UIView) -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: view, action: #selector(endEditing))
    }
    
    @objc private func endEditing() {
        print("self: \(self)")
//        self.view.endEditing(true)
    }
}
