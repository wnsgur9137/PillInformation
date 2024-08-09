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
                                               collectionViewDataSource: reactor)
            bindAdapter(reactor)
        }
        addSubviews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
            .map { Reactor.Action.loadPills }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.loadBookmark }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.dismissButton.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.shapeSearchButton.rx.tap
            .map { Reactor.Action.didTapSearchShapeButton }
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
                self?.searchResultEmptyView.stopAnimation()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$reloadItem)
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] indexPath in
                guard let indexPath = indexPath else { return }
                self?.collectionView.reloadItems(at: [indexPath])
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isEmpty)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = false
                self?.searchResultEmptyView.playAnimation()
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
    
    private func bindAdapter(_ reactor: SearchResultReactor) {
        adapter?.didSelectItem
            .map { indexPath in
                Reactor.Action.didSelectItem(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectBookmark
            .map { indexPath in
                Reactor.Action.didSelectBookmark(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.shouldReturn
            .map { keyword in
                Reactor.Action.search(keyword)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
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
