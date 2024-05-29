//
//  TableFooterView.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 5/14/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

public final class TableFooterView: UITableViewHeaderFooterView {
    
    private let footerView = FooterView()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(footerView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        footerView.pin.all()
        footerView.flex.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
