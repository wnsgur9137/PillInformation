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
    
    private let searchTextFieldView = SearchTextFieldView(hasDismiss: true)
    private let searchResultEmptyView: SearchResultEmptyView = {
        let view = SearchResultEmptyView()
        view.isHidden = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Constants.Color.background
        return collectionView
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchResultAdapter?
    
    private let searchRelay: PublishRelay<String?> = .init()
    private let didSelectItemRelay: PublishRelay<IndexPath> = .init()
    
    
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
                                               textField: searchTextFieldView.searchTextField,
                                               collectionViewDataSource: reactor,
                                               collectionViewDelegate: self,
                                               textFieldDelegate: self)
        }
        addSubviews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchResultReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showAlert(title: String?, message: String?) {
        let title = AlertText(text: title ?? "")
        let message = AlertText(text: message ?? "")
        let confirmButton = AlertButtonInfo(title: Constants.confirm)
        AlertViewer()
            .showSingleButtonAlert(self,
                                   title: title,
                                   message: message,
                                   confirmButtonInfo: confirmButton)
    }
}

// MARK: - Binding
extension SearchResultViewController {
    private func bindAction(_ reactor: SearchResultReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.dismissButton.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchRelay
            .map { text in
                Reactor.Action.search(text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectItemRelay
            .map { indexPath in
                Reactor.Action.didSelectItem(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchResultReactor) {
        reactor.state
            .map { $0.keyword }
            .bind(to: searchTextFieldView.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$reloadData)
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = true
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isEmpty)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertContents)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] content in
                self?.showAlert(title: content?.title, message: content?.message)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - SearchResultAdapter CollectionViewDelegate
extension SearchResultViewController: SearchResultCollectionViewDelegate {
    public func didSelectItem(at indexPath: IndexPath) {
        didSelectItemRelay.accept(indexPath)
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
        searchTextFieldView.pin.left().right().top(view.safeAreaInsets.top)
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
