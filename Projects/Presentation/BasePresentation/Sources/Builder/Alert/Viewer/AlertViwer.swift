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
    
    public func attachAlert(viewController: UIViewController,
                             alert: AlertView) {
        viewController.view.addSubview(dimmed)
        viewController.view.fit(target: dimmed)
        
        viewController.view.addSubview(alert)
        viewController.view.addCenterXConstraint(target: alert, constant: 0)
        viewController.view.addCenterYConstraint(target: alert, constant: 0)
        
        alert.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 0.8).isActive = true
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
    func showSingleButtonAlert(_ viewController: UIViewController,
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
        
        attachAlert(viewController: viewController, alert: alertBuilder.alert)
    }
    
    func showSingleButtonAlert(_ viewController: UIViewController,
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
        
        attachAlert(viewController: viewController, alert: alertBuilder.alert)
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
    func showDualButtonAlert(_ viewController: UIViewController,
                             image: UIImage? = nil,
                             title: AlertText?,
                             message: AlertText? = nil,
                             confirmButtonInfo: AlertButtonInfo,
                             cancelButtonInfo: AlertButtonInfo) {
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
            .setupCancelButton(.init(title: cancelButtonInfo.title,
                                     isEnabled: cancelButtonInfo.isEnabled,
                                     action: {
                dimmed.removeFromSuperview()
                cancelButtonInfo.action()
            }))
        
        attachAlert(viewController: viewController, alert: alertBuilder.alert)
    }
    
    /// Default Dual button Alert
    /// - Parameters:
    ///   - viewController: Alert을 표시할 UIViewController
    ///   - image: 상단 이미지
    ///   - title: 타이틀
    ///   - message: 메세지
    ///   - confirmButtonInfo: 확인 버튼 설정 정보
    ///   - cancelButtonInfo: 취소 버튼 설정 정보
    func showDualButtonAlet(_ viewController: UIViewController,
                            image: UIImage? = nil,
                            title: AlertText?,
                            message: AlertAttributedText? = nil,
                            confirmButtonInfo: AlertButtonInfo,
                            cancelButtonInfo: AlertButtonInfo) {
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
            .setupCancelButton(.init(title: cancelButtonInfo.title,
                                     isEnabled: cancelButtonInfo.isEnabled,
                                     action: {
                dimmed.removeFromSuperview()
                cancelButtonInfo.action()
            }))
        
        attachAlert(viewController: viewController, alert: alertBuilder.alert)
    }
}
