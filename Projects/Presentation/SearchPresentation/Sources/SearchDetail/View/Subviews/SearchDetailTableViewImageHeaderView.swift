//
//  SearchDetailTableViewImageHeaderView.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/13/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class SearchDetailTableViewImageHeaderView: UITableViewHeaderFooterView {
    
    private(set) var disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.all()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
