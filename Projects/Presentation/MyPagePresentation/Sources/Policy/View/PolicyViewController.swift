//
//  PolicyViewController.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import WebKit
import ReactorKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

import BasePresentation

public final class PolicyViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Policy"
        label.textColor = .label
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.xmark, for: .normal)
        button.tintColor = Constants.Color.systemLabel
        return button
    }()
    
    private var webView: WKWebView?
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: PolicyAdapter?
    
    // MARK: - Life cycle
    public static func create(with reactor: PolicyReactor) -> PolicyViewController {
        let viewController = PolicyViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setWebView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor,
           let webView = webView {
            adapter = PolicyAdapter(webView: webView,
                                         delegate: self)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "URL")
    }
    
    public func bind(reactor: PolicyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setWebView() {
        
        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = [.all]
        
        let wkWebView = WKWebView(frame: .zero, configuration: config)
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.webView = wkWebView
    }
    
    public override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "URL",
              object is WKWebView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
    }
    
    private func loadWebView(_ url: URL) {
        guard let webView = webView else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.main.async {
//            webView.load(urlRequest)
        }
    }
}

// MARK: - Binding
extension PolicyViewController {
    private func bindAction(_ reactor: PolicyReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: PolicyReactor) {
        reactor.state
            .map { $0.url }
            .filter { $0 != nil }
            .bind(onNext: { url in
                guard let url = url else { return }
                self.loadWebView(url)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PolicyAdapter Delegate
extension PolicyViewController: PolicyAdapterDelegate {
    
}

// MARK: - Layout
extension PolicyViewController {
    private func setupLayout() {
        guard let webView = webView else {
            // TODO: - Show retry alert
            return
        }
        view.addSubview(rootContainerView)
        view.addSubview(backButton)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .marginTop(24.0)
                .marginLeft(12.0)
            rootView.addItem(webView)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
        
        backButton.pin.top(24.0).right(24.0).width(48.0).height(48.0)
    }
}
