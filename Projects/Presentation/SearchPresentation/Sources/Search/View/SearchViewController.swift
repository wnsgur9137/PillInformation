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
import RxDataSources
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
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteBold(24.0)
        return label
    }()
    
    private let recommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecommendKeywordCollectionViewCell.self, forCellWithReuseIdentifier: RecommendKeywordCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let recentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecentTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentTableViewHeaderView.identifier)
        tableView.register(RecentTableViewCell.self, forCellReuseIdentifier: RecentTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    private let searchRelay: PublishRelay<String?> = .init()
    private let didSelectTableViewDeleteButton: PublishRelay<IndexPath> = .init()
    private let didSelectRecentDeleteAllKeywordButton: PublishRelay<Void> = .init()
    private let deleteAllRecentKeywords: PublishRelay<Void> = .init()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: SearchReactor) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        rootContainerView.backgroundColor = Constants.Color.background
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextFieldView.searchTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchReactor) {
        bindDelegate()
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func createCollectionViewDataSource() -> RxCollectionViewSectionedAnimatedDataSource<RecommendCollectionViewSectionModel> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<RecommendCollectionViewSectionModel> { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendKeywordCollectionViewCell.identifier, for: indexPath) as? RecommendKeywordCollectionViewCell else { return .init() }
            cell.configure(text: item)
            return cell
        }
        return dataSource
    }
    
    private func createTableViewDataSource() -> RxTableViewSectionedReloadDataSource<RecentTableViewSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<RecentTableViewSectionModel> { [weak self] _, tableView, indexPath, item in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else { return .init() }
            cell.configure(text: item)
            cell.deleteButton.rx.tap
                .map { _ in return indexPath}
                .bind(to: self.didSelectTableViewDeleteButton)
                .disposed(by: cell.disposeBag)
            return cell
        }
        return dataSource
    }
    
    private func showDeleteAllAlert() {
        AlertViewer()
            .showDualButtonAlert(
                in: view,
                title: .init(text: Constants.Search.askDeleteAll),
                message: nil,
                confirmButtonInfo: .init(title: Constants.Search.delete) {
                    self.deleteAllRecentKeywords.accept(Void())
                },
                cancelButtonInfo: .init(title: Constants.cancel)
            )
    }
}

// MARK: - Binding
extension SearchViewController {
    private func bindDelegate() {
        recommendCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        recentTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: SearchReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.loadRecommendKeyword }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { Reactor.Action.loadRecentKeyword }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.shapeSearchButton.rx.tap
            .map { Reactor.Action.didSelectSearchShapeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectRecentDeleteAllKeywordButton
            .map { Reactor.Action.didSelectTableViewDeleteAllButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteAllRecentKeywords
            .map { Reactor.Action.deleteAllRecentKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectTableViewDeleteButton
            .map { indexPath in Reactor.Action.didSelectTableViewDeleteButton(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        recommendCollectionView.rx.itemSelected
            .map { indexPath in Reactor.Action.didSelectCollectionViewItem(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        recentTableView.rx.itemSelected
            .map { indexPath in Reactor.Action.didSelectTableViewRow(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .map {  Reactor.Action.search(self.searchTextFieldView.searchTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchReactor) {
        reactor.pulse(\.$alertContents)
            .filter { $0.isNotNull }
            .subscribe(onNext: { contents in
                guard let contents = contents else { return }
                let title = AlertText(text: contents.title)
                let message = AlertText(text: contents.message ?? "")
                let confirmButtonInfo = AlertButtonInfo(title: Constants.confirm)
                AlertViewer()
                    .showSingleButtonAlert(
                        in: self.view,
                        title: title,
                        message: message,
                        confirmButtonInfo: confirmButtonInfo
                    )
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$collectionViewItems)
            .bind(to: recommendCollectionView.rx.items(dataSource: createCollectionViewDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$tableViewItems)
            .bind(to: recentTableView.rx.items(dataSource: createTableViewDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$showDeleteAllRecentKeywordAlert)
            .filter { $0.isNotNull }
            .subscribe(onNext: { _ in
                self.showDeleteAllAlert()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = reactor?.recommendKeywords[indexPath.item] else { return .init() }
        let textSize = (text as NSString).size(withAttributes: [
            NSAttributedString.Key.font: Constants.Font.suiteMedium(20.0)
        ])
        let width = ceil(textSize.width) + 24.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentTableViewHeaderView.identifier) as? RecentTableViewHeaderView else { return nil }
        view.deleteAllButton.rx.tap
            .bind(to: didSelectRecentDeleteAllKeywordButton)
            .disposed(by: view.disposeBag)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
