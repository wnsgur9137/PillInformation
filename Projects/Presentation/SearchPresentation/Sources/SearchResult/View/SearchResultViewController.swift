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
    
    private let searchTextFieldView = SearchTextFieldView()
    private let searchResultEmptyView: SearchResultEmptyView = {
        let view = SearchResultEmptyView()
        view.isHidden = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchResultAdapter?
    
    private let searchRelay: PublishRelay<String?> = .init()
    
    
    // MARK: - LifeCycle
    public static func create(with reactor: SearchResultReactor) -> SearchResultViewController {
        let viewController = SearchResultViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = SearchResultAdapter(collectionView: collectionView,
                                               textField: searchTextFieldView.searchTextField,
                                               collectionViewDataSource: reactor,
                                               collectionViewDelegate: self,
                                               textFieldDelegate: self)
        }
        addSubviews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchResultReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension SearchResultViewController {
    private func bindAction(_ reactor: SearchResultReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchRelay
            .map { text in
                Reactor.Action.search(text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchResultReactor) {
        reactor.pulse(\.$reloadData)
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = true
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isEmpty)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler())
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler())
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - SearchResultAdapter CollectionViewDelegate
extension SearchResultViewController: SearchResultCollectionViewDelegate {
    public func didSelectItem(at indexPath: IndexPath) {
        
    }
}

// MARK: - SearchResultAdapter TextFieldDelegate
extension SearchResultViewController: SearchResultTextFieldDelegate {
    public func shouldReturn(text: String?) {
        searchRelay.accept(text)
    }
}

// MARK: - Layout
extension SearchResultViewController {
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchTextFieldView)
        view.addSubview(searchResultEmptyView)
    }
    
    private func setupSubviewLayout() {
        searchTextFieldView.pin
            .left(24.0)
            .right(24.0)
            .height(48.0)
            .top(view.safeAreaInsets.top)
        searchTextFieldView.flex.layout()
        
        collectionView.pin
            .top(to: searchTextFieldView.edge.bottom).marginTop(10.0)
            .horizontally()
            .bottom()
        collectionView.flex.layout()
        
        searchResultEmptyView.pin
            .top(to: searchTextFieldView.edge.bottom).marginTop(10.0)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
        searchResultEmptyView.flex.layout()
    }
    
    private func updateSubviewLayout() {
        
    }
}
