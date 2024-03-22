//
//  SearchViewController.swift
//  Search
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import FlexLayout
import PinLayout

import BasePresentation

public final class SearchViewController: UIViewController, View {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var navigationView = NavigationView(useTextField: true)
    
    private let keyboardBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let recentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = .label
        return label
    }()
    
    private let footerView = FooterView()
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchAdapter?
    
    // MARK: - LifeCycle
    
    public func create(with reactor: SearchReactor) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        if let reactor = reactor {
            self.adapter = SearchAdapter(collectionView: recentCollectionView,
                                         dataSource: reactor,
                                         delegate: self)
        }
        setupKeyboard()
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationView.textField.becomeFirstResponder()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Functions
extension SearchViewController {
    private func setupKeyboard() {
        keyboardBackgroundView.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        rx.showKeyboard
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] _ in
                self?.keyboardBackgroundView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        rx.hideKeyboard
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] _ in
                self?.keyboardBackgroundView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding
extension SearchViewController {
    public func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SearchReactor) {
        navigationView.searchButton.rx.tapGesture()
            .map { _ in Reactor.Action.search(self.navigationView.textField.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchReactor) {
        
    }
}

// MARK: - SearchAdapter Delegate
extension SearchViewController: SearchAdapterDelegate {
    
}

// MARK: - Layout
extension SearchViewController {
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(keyboardBackgroundView)
        view.addSubview(navigationView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView)
                .marginTop(navigationView.height)
                .define { contentView in
                    contentView.addItem(recentCollectionView)
                        .margin(UIEdgeInsets(top: 12.0, left: 0, bottom: 12.0, right: 0))
                        .height(60.0)
                    contentView.addItem(label)
                    contentView.addItem(footerView)
                }
        }
    }
    
    private func setupSubviewLayout() {
        keyboardBackgroundView.pin.all()
        navigationView.pin.left().right().top(view.safeAreaInsets.top)
        navigationView.flex.layout()
        scrollView.pin.left().right().bottom().top(view.safeAreaInsets.top)
        scrollView.flex.layout()
        contentView.flex.layout()
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height + navigationView.height)
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.flex.layout()
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height + navigationView.height)
    }
}
