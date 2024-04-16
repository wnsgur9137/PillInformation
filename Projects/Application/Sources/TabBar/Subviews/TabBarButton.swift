//
//  TabBarButton.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 4/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

final class TabBarButton: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let height: CGFloat = (CGSize.deviceSize.width / 7.8) / 2
    
    var defaultColor: UIColor = Constants.Color.systemLightGray
    var selectedColor: UIColor = Constants.Color.systemBlue
    var defaultImage: UIImage?
    var selectedImage: UIImage?
    
    var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? selectedColor : defaultColor
            imageView.image = isSelected ? selectedImage : defaultImage
        }
    }
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
        super.init(frame: .zero)
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(_ action: UIAction, for event: UIControl.Event) {
        button.addAction(action, for: event)
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(button)
    }
    
    private func setupLayoutConstraints() {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

