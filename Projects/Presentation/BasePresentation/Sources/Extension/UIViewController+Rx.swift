//
//  UIViewController+Rx.swift
//  Common
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum ViewControllerState {
    case notloaded, hidden, hiding, showing, shown
}

extension Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(base.viewDidLoad)).map{ _ in }
    }
    public var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:))).map{ _ in }
    }
    public var viewDidAppear: Observable<Void> {
        return sentMessage(#selector(base.viewDidAppear(_:))).map{ _ in }
    }
    public var viewDidDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewDidDisappear(_:))).map{ _ in }
    }
    public var viewWillDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewWillDisappear(_:))).map{ _ in }
    }
    public var viewDidLayoutSubviews: Observable<Void> {
        return sentMessage(#selector(base.viewDidLayoutSubviews)).map{ _ in }
    }
    public var viewEvent: Observable<ViewControllerState> {
        let willAppear = viewWillAppear.map{ _ -> ViewControllerState in return .showing }
        let didAppear = viewDidAppear.map{ _ -> ViewControllerState in return .shown }
        let willDisappear = viewWillDisappear.map{ _ -> ViewControllerState in return .hiding }
        let didDisappear = viewDidDisappear.map{ _ -> ViewControllerState in return .hidden }
        return  Observable.of(willAppear,didAppear,willDisappear,didDisappear).merge()
    }
}

// MARK: - UIView
extension Reactive where Base: UIView {
    public var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}
