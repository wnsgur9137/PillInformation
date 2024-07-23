//
//  SearchDetailViewController.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout

public protocol SearchDetailViewControllerProtocol: UIViewController {
    
    var searchDetailView: SearchDetailView { get set }
    var capsuleView: CapsuleView? { get set }
    
    var medicineName: String  { get set }
    var imageHeaderViewHeight: CGFloat { get set }
    var footerViewHeight: CGFloat { get set }
    
    func configure(_ pillInfo: PillInfoModel)
    func showPasteboardCapsule()
}

public extension SearchDetailViewControllerProtocol {
    var medicineName: String {
        return ""
    }
    
    var imageHeaderViewHeight: CGFloat {
        return 300.0
    }
    
    var footerViewHeight: CGFloat {
        return 300.0
    }
    
    func configure(_ pillInfo: PillInfoModel) {
        medicineName = pillInfo.medicineName
        searchDetailView.navigationTitleLabel.text = medicineName
        searchDetailView.titleLabel.text = medicineName
    }
    
    func showPasteboardCapsule() {
        if capsuleView == nil {
            capsuleView = CapsuleView(Constants.Search.copyComplete)
            capsuleView?.translatesAutoresizingMaskIntoConstraints = false
            guard let capsuleView = capsuleView else { return }
            view.addSubview(capsuleView)
            capsuleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            capsuleView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            capsuleView.widthAnchor.constraint(greaterThanOrEqualToConstant: capsuleView.minWidth).isActive = true
            capsuleView.heightAnchor.constraint(equalToConstant: capsuleView.height).isActive = true
        }
        guard let capsuleView = capsuleView else { return }
        let y = capsuleView.height + 20
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            capsuleView.transform = .init(translationX: 0, y: -y)
        } completion: { _ in
            // TODO: - 17.0 이상으로 올린 후 capsuleView.imageView.image에 bounce 주기
            UIView.animate(withDuration: 1,
                           delay: 0.5,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut) {
                capsuleView.transform = .init(translationX: 0, y: y)
            }
        }
    }
    
    func setupLayout() {
        view.addSubview(searchDetailView)
    }
    
    func setupSubviewLayout() {
        searchDetailView.pin.all()
        searchDetailView.flex.layout()
    }
    
    private func updateSubviewLayout() {
        searchDetailView.updateSubviewLayout()
    }
}
