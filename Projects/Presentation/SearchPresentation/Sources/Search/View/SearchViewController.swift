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
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let searchTextFieldView = SearchTextFieldView()
    
    private let recommendLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Search.recommendKeyword
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(24.0)
        return label
    }()
    
    private let recommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let recentTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchAdapter?
    
    private let searchRelay: PublishRelay<String?> = .init()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: SearchReactor) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        rootContainerView.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = SearchAdapter(
                collectionView: recommendCollectionView,
                tableView: recentTableView,
                textField: searchTextFieldView.searchTextField,
                dataSource: reactor
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextFieldView.searchTextField.becomeFirstResponder()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension SearchViewController {
    private func bindAction(_ reactor: SearchReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.loadRecommendKeyword }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { Reactor.Action.loadRecentKeyword }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchRelay
            .map { text in
                Reactor.Action.search(text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.alertContents }
            .bind(onNext: { contents in
                guard let contents = contents else { return }
                let title = AlertText(text: contents.title)
                let message = AlertText(text: contents.message ?? "")
                let confirmButtonInfo = AlertButtonInfo(title: "확인")
                AlertViewer()
                    .showSingleButtonAlert(self, 
                                           title: title,
                                           message: message,
                                           confirmButtonInfo: confirmButtonInfo)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.reloadCollectionViewData }
            .bind(onNext: {
                self.recommendCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.reloadTableViewData }
            .bind(onNext: {
                self.recentTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: SearchReactor) {
        adapter?.shouldReturn
            .map { keyword in Reactor.Action.search(keyword) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectCollectionViewItem
            .map { indexPath in Reactor.Action.didSelectCollectionViewItem(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectTableViewRow
            .map { indexPath in Reactor.Action.didSelectTableViewRow(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectTableViewDeleteButton
            .map { indexPath in Reactor.Action.didSelectTableViewDeleteButton(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectTableViewDeleteAllButton
            .map { Reactor.Action.didSelectTableViewDeleteAllButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension SearchViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        view.addSubview(searchTextFieldView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem()
                .marginTop(12.0)
                .backgroundColor(Constants.Color.systemBackground)
                .height(80.0)
                .justifyContent(.center)
                .define {
                    $0.addItem(recommendLabel)
                        .marginTop(10.0)
                        .marginLeft(12.0)
                }
            rootView.addItem(recommendCollectionView)
                .height(60.0)
            rootView.addItem(recentTableView)
                .marginTop(12.0)
                .grow(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        searchTextFieldView.pin.left().right().top(view.safeAreaInsets.top)
        searchTextFieldView.flex.layout()
        rootContainerView.pin.left().right().top(to: searchTextFieldView.edge.bottom).bottom(view.safeAreaInsets.bottom)
        rootContainerView.flex.layout()
    }
}
