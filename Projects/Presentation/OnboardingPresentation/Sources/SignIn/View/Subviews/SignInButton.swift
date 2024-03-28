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
            case .google: return Constants.Color.googleBlue
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .apple: return Constants.Color.systemBackground
            case .kakao: return Constants.Color.systemWhite
            case .google: return Constants.Color.systemBlack
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
    
    private let rootFlexConatainerView = UIView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.button1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Properties
    
    private let signInType: SignInType
    
    // MARK: - Lifecycle
    
    init(type: SignInType) {
        self.signInType = type
        super.init(frame: .zero)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - Functions
extension SignInButton {
    private func setupButton() {
        backgroundColor = signInType.backGroundColor
        layer.cornerRadius = 24.0
        layer.addShadow()
    }
    
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
        let width = (UIScreen.main.bounds.width / 4) * 3
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        addSubview(rootFlexConatainerView)
        
        rootFlexConatainerView.flex.define { rootView in
            rootView.addItem()
                .direction(.row)
                .define { contentStack in
                    contentStack.addItem(iconImageView)
                    contentStack.addItem(label)
            }
        }
    }
    
    private func setupSubviewLayout() {
        rootFlexConatainerView.pin.all()
        rootFlexConatainerView.flex.layout()
    }
}

