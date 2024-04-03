//
//  AlertBuilder.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

public struct AlertText {
    let text: String
    let color: UIColor
    let alignment: NSTextAlignment
    
    public init(text: String,
                color: UIColor = .label,
                alignment: NSTextAlignment = .center) {
        self.text = text
        self.color = color
        self.alignment = alignment
    }
}

public struct AlertAttributedText {
    let attributedText: NSAttributedString
    let alignment: NSTextAlignment
    
    public init(attributedText: NSAttributedString,
                alignment: NSTextAlignment = .center) {
        self.attributedText = attributedText
        self.alignment = alignment
    }
}

public struct AlertButtonInfo {
    let title: String?
    let isEnabled: Bool
    let action: () -> Void
    
    public init(title: String?,
                isEnabled: Bool = true,
                action: @escaping () -> Void = {}) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
}

public struct AlertBuilder {
    typealias ButtonAction = () -> Void
    let alert: AlertView = {
        let view = AlertView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let disposeBag = DisposeBag()
}

extension AlertBuilder {
    
    
    /// 팝업 이미지 추가
    /// - Parameter imageName: 이미지 이름(String)
    @discardableResult
    public func setupPopupImage(_ imageName: String?) -> Self {
        guard let imageName = imageName else { return self }
        alert.setup(popupImageName: imageName)
        return self
    }
    
    /// 팝업 이미지 추가
    /// - Parameter image: 이미지(UIImage)
    @discardableResult
    public func setupPopupImage(_ image: UIImage?) -> Self {
        guard let image = image else { return self }
        alert.setup(popupImage: image)
        return self
    }
    
    
    /// 타이틀 추가
    /// - Parameter title: 타이틀(AlertText)
    @discardableResult
    public func addTitleLabel(_ title: AlertText?) -> Self {
        guard let title = title else { return self }
        alert.addTitleLabel(.button(title.text,
                                    color: title.color,
                                    alignment: title.alignment))
        return self
    }
    
    /// 타이틀 추가
    /// - Parameter title: 타이틀(String)
    @discardableResult
    public func addTitleLabel(_ title: String?) -> Self {
        guard let title = title else { return self }
        alert.addTitleLabel(title)
        return self
    }
    
    /// 메세지 추가
    /// - Parameter message: 메세지(AlertText)
    @discardableResult
    public func addMessageLabel(_ message: AlertText?) -> Self {
        guard let message = message else { return self }
        alert.addMessageLabel(.button(message.text,
                                      color: message.color,
                                      alignment: message.alignment))
        return self
    }
    
    /// 메세지 추가
    /// - Parameter message: 메세지(AlertAttributedText)
    @discardableResult
    public func addMessageLabel(_ message: AlertAttributedText?) -> Self {
        guard let message = message else { return self }
        alert.addMessageLabel(message.attributedText)
        return self
    }
    
    /// 메세지 추가
    /// - Parameter message: 메세지(String)
    @discardableResult
    public func addMessageLabel(_ message: String?) -> Self {
        guard let message = message else { return self }
        alert.addMessageLabel(message)
        return self
    }
    
    /// 확인 버튼 설정
    /// - Parameter info: 설정(AlertButtonInfo)
    @discardableResult
    public func setupConfirmButton(_ info: AlertButtonInfo) -> Self {
        alert.confirmButton.title = info.title ?? ""
        alert.confirmButton.isEnabled = info.isEnabled
        alert.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {
                alert.removeFromSuperview()
                info.action()
            })
            .disposed(by: disposeBag)
        return self
    }
    
    /// 취소 버튼 설정
    /// - Parameter info: 설정(AlertButtonInfo)
    @discardableResult
    public func setupCancelButton(_ info: AlertButtonInfo) -> Self {
        alert.cancelButton.title = info.title ?? ""
        alert.cancelButton.isEnabled = info.isEnabled
        alert.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {
                alert.removeFromSuperview()
                info.action()
            })
            .disposed(by: disposeBag)
        alert.setupCancelButton()
        return self
    }
}
