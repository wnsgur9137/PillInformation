//
//  SearchResultViewController.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
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

public final class SearchResultViewController: UIViewController, View {
    
    private let navigationView = NavigationView(useTextField: true)
    private let keyboardBackgroundView = UIView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let footerView = FooterView()
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchResultAdapter?
    
    // MARK: - LifeCycle
    public static func create(with reactor: SearchResultReactor) -> SearchResultViewController {
        let viewController = SearchResultViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        if let reactor = reactor {
            self.adapter = SearchResultAdapter(collectionView: collectionView,
                                               dataSource: reactor,
                                               deleagte: self)
        }
        setupKeyboard()
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
}

// MARK: - Functions
extension SearchResultViewController {
    private func setupKeyboard() {
        keyboardBackgroundView.rx.tapGesture()
            .asDriver(onErrorDriveWith: .never())
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
extension SearchResultViewController {
    public func bind(reactor: SearchResultReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SearchResultReactor) {
        
    }
    
    private func bindState(_ reactor: SearchResultReactor) {
        
    }
}

// MARK: - SearchResultAdapter Delegate
extension SearchResultViewController: SearchResultAdapterDelegate {
    
}

// MARK: - Layout
extension SearchResultViewController {
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(keyboardBackgroundView)
        view.addSubview(navigationView)
        
        collectionView.flex.define { collectionView in
            
        }
    }
    
    private func setupSubviewLayout() {
        keyboardBackgroundView.pin.all()
        navigationView.pin.left().right().top(view.safeAreaInsets.top)
        navigationView.flex.layout()
        collectionView.pin.all()
        collectionView.flex.layout()
    }
    
    private func updateSubviewLayout() {
        
    }
}
