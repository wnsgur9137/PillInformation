//
//  PolicyAdapter.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

public protocol PolicyAdapterDelegate: AnyObject {
    
}

public final class PolicyAdapter: NSObject {
    private let webView: WKWebView
    private weak var delegate: PolicyAdapterDelegate?
    
    init(webView: WKWebView,
         delegate: PolicyAdapterDelegate) {
        self.webView = webView
        self.delegate = delegate
        super.init()
        
        self.webView.scrollView.delegate = self
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
}

// MARK: - UIScrollViewDelegate
extension PolicyAdapter: UIScrollViewDelegate {
    
}

// MARK: - WKNavigationDelegate
extension PolicyAdapter: WKNavigationDelegate {
    
}

// MARK: - WKUIDelegate
extension PolicyAdapter: WKUIDelegate {
    
}
