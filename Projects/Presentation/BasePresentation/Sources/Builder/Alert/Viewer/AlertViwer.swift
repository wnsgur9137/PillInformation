//
//  AlertViwer.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public struct AlertViewer {
    typealias ButtonAction = () -> Void
    
    private let dimmed: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Color.dimBlack
        return view
    }()
    
    public func attachAlert(in view: UIView,
                             alert: AlertView) {
        view.addSubview(dimmed)
        view.fit(target: dimmed)
        
        view.addSubview(alert)
        alert.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alert.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alert.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    public init() {
        
    }
}

// MARK: - SingleButton Alert
extension AlertViewer {
    
    
    /// Default Single button Alert
    /// - Parameters:
    ///   - viewController: Alert을 표시할 UIViewController
    ///   - image: 상단 이미지
    ///   - title: 타이틀
    ///   - message: 메세지
    ///   - confirmButtonInfo: 확인 버튼 설정 정보
    public func showSingleButtonAlert(in view: UIView,
                               image: UIImage? = nil,
                               title: AlertText?,
                               message: AlertText? = nil,
                               confirmButtonInfo: AlertButtonInfo) {
        let alertBuilder = AlertBuilder()
            .setupPopupImage(image)
            .addTitleLabel(title)
            .addMessageLabel(message)
            .setupConfirmButton(.init(title: confirmButtonInfo.title,
                                      isEnabled: confirmButtonInfo.isEnabled,
                                      action: {
                dimmed.removeFromSuperview()
                confirmButtonInfo.action()
            }))
        
        attachAlert(in: view, alert: alertBuilder.alert)
    }
    
    public func showSingleButtonAlert(in view: UIView,
                               image: UIImage? = nil,
                               title: AlertText?,
                               message: AlertAttributedText,
                               confirmButtonInfo: AlertButtonInfo) {
        let alertBuilder = AlertBuilder()
            .setupPopupImage(image)
            .addTitleLabel(title)
            .addMessageLabel(message)
            .setupConfirmButton(.init(title: confirmButtonInfo.title,
                                      isEnabled: confirmButtonInfo.isEnabled,
                                      action: {
                dimmed.removeFromSuperview()
                confirmButtonInfo.action()
            }))
        
        attachAlert(in: view, alert: alertBuilder.alert)
    }
}

// MARK: - DualButton Alert
extension AlertViewer {
    
    /// Default Dual button Alert
    /// - Parameters:
    ///   - viewController: Alert을 표시할 UIViewController
    ///   - image: 상단 이미지
    ///   - title: 타이틀
    ///   - message: 메세지
    ///   - confirmButtonInfo: 확인 버튼 설정 정보
    ///   - cancelButtonInfo: 취소 버튼 설정 정보
    public func showDualButtonAlert(in view: UIView,
                             image: UIImage? = nil,
                             title: AlertText?,
                             message: AlertText?,
                             confirmButtonInfo: AlertButtonInfo,
                             cancelButtonInfo: AlertButtonInfo) {
        let alertBuilder = AlertBuilder()
            .setupPopupImage(image)
            .addTitleLabel(title)
            .addMessageLabel(message)
            .setupCancelButton(.init(title: cancelButtonInfo.title,
                                     isEnabled: cancelButtonInfo.isEnabled,
                                     action: {
                dimmed.removeFromSuperview()
                cancelButtonInfo.action()
            }))
            .setupConfirmButton(.init(title: confirmButtonInfo.title,
                                      isEnabled: confirmButtonInfo.isEnabled,
                                      action: {
                dimmed.removeFromSuperview()
                confirmButtonInfo.action()
            }))
        
        attachAlert(in: view, alert: alertBuilder.alert)
    }
    
    /// Default Dual button Alert
    /// - Parameters:
    ///   - viewController: Alert을 표시할 UIViewController
    ///   - image: 상단 이미지
    ///   - title: 타이틀
    ///   - message: 메세지
    ///   - confirmButtonInfo: 확인 버튼 설정 정보
    ///   - cancelButtonInfo: 취소 버튼 설정 정보
    public func showDualButtonAlert(in view: UIView,
                            image: UIImage? = nil,
                            title: AlertText?,
                            attributedMessage: AlertAttributedText? = nil,
                            confirmButtonInfo: AlertButtonInfo,
                            cancelButtonInfo: AlertButtonInfo) {
        let alertBuilder = AlertBuilder()
            .setupPopupImage(image)
            .addTitleLabel(title)
            .addMessageLabel(attributedMessage)
            .setupCancelButton(.init(title: cancelButtonInfo.title,
                                     isEnabled: cancelButtonInfo.isEnabled,
                                     action: {
                dimmed.removeFromSuperview()
                cancelButtonInfo.action()
            }))
            .setupConfirmButton(.init(title: confirmButtonInfo.title,
                                      isEnabled: confirmButtonInfo.isEnabled,
                                      action: {
                dimmed.removeFromSuperview()
                confirmButtonInfo.action()
            }))
        
        attachAlert(in: view, alert: alertBuilder.alert)
    }
}
