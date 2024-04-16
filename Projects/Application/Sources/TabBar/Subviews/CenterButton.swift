//
//  CenterButton.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 4/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

final class CenterButton: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let width: CGFloat = CGSize.deviceSize.width / 7.8
    
    var isSelected: Bool = false {
        didSet {
            imageView.tintColor = isSelected ? Constants.Color.systemWhite : Constants.Color.systemLightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.systemBlue
        layer.cornerRadius = width / 2
        clipsToBounds = true
        layer.addShadow()
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.isSelected = !self.isSelected
        }), for: .touchUpInside)
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(button)
    }
    
    private func setupLayoutConstraints() {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: width).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14.0).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 14.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
