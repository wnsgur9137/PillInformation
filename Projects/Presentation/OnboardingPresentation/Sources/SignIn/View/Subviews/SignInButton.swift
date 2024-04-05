//
//  SignInButton.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

final class SignInButton: UIButton {
    
    enum SignInType {
        case apple
        case kakao
        case google
        
        var backGroundColor: UIColor {
            switch self {
            case .apple: return Constants.Color.systemLabel
            case .kakao: return Constants.Color.kakaoYellow
            case .google: return Constants.Color.systemBackground
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .apple: return Constants.Color.systemBackground
            case .kakao: return Constants.Color.systemBlack
            case .google: return Constants.Color.systemLabel
            }
        }
        
        var text: String {
            switch self {
            case .apple: return Constants.SignIn.appleLogin
            case .kakao: return Constants.SignIn.kakaoLogin
            case .google: return Constants.SignIn.googleLogin
            }
        }
        
        var image: UIImage {
            switch self {
            case .apple: return Constants.SignIn.Image.appleLogo
            case .kakao: return Constants.SignIn.Image.kakaoLogo
            case .google: return Constants.SignIn.Image.googleLogo
            }
        }
    }
    
    // MARK: - UI Instances
    
    private let rootFlexConatainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let buttonWidth = (CGSize.deviceSize.width / 5) * 4
    private let buttonHeight = 50.0
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.button1
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    // MARK: - Properties
    
    private let signInType: SignInType
    
    // MARK: - Lifecycle
    
    init(type: SignInType) {
        self.signInType = type
        super.init(frame: .zero)
        layer.addShadow()
        setupTitleLabel()
        setupIconImageView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Methods
extension SignInButton {
    private func setupTitleLabel() {
        label.text = signInType.text
        label.textColor = signInType.textColor
    }
    
    private func setupIconImageView() {
        iconImageView.image = signInType.image
    }
}


// MARK: - Layout
extension SignInButton {
    private func setupLayout() {
        addSubview(rootFlexConatainerView)
        
        rootFlexConatainerView.flex
            .backgroundColor(signInType.backGroundColor)
            .width(buttonWidth)
            .height(buttonHeight)
            .cornerRadius(buttonHeight / 3)
            .define { rootView in
                rootView.addItem()
                    .direction(.row)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .define { contentStack in
                        contentStack.addItem(iconImageView)
                            .width(18.0)
                            .height(18.0)
                        contentStack.addItem(label)
                            .marginLeft(10.0)
                            .height(buttonHeight)
                    }
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexConatainerView.pin.all()
        rootFlexConatainerView.flex.layout()
    }
}

