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
import RxDataSources
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
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchResultAdapter?
    private let didSelectBookmark: PublishRelay<IndexPath> = .init()
    
    // MARK: - LifeCycle
    public static func create(with reactor: SearchResultReactor) -> SearchResultViewController {
        let viewController = SearchResultViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
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
        bindDelegate()
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SearchResultSectionedItem> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SearchResultSectionedItem> { [weak self] _, collectionView, indexPath, item in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return .init() }
            cell.showAnimatedGradientSkeleton()
            cell.configure(item.pill, isBookmarked: item.isBookmarked)
            cell.bookmarkButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    cell.isBookmarked = !cell.isBookmarked
                    self?.didSelectBookmark.accept(indexPath)
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
        return dataSource
    }
    
    private func showAlert(title: String?, message: String?) {
        let title = AlertText(text: title ?? "")
        let message = AlertText(text: message ?? "")
        let confirmButton = AlertButtonInfo(title: Constants.confirm)
        AlertViewer()
            .showSingleButtonAlert(
                in: view,
                title: title,
                message: message,
                confirmButtonInfo: confirmButton
            )
    }
}

// MARK: - Binding
extension SearchResultViewController {
    private func bindDelegate() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
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
        
        searchTextFieldView.searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .map { [weak self] in
                Reactor.Action.search(self?.searchTextFieldView.searchTextField.text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { indexPath in Reactor.Action.didSelectItem(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectBookmark
            .map { indexPath in Reactor.Action.didSelectBookmark(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchResultReactor) {
        reactor.state
            .map { $0.keyword }
            .bind(to: searchTextFieldView.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$searchResultItems)
            .map { [weak self] items in
                self?.searchResultEmptyView.isHidden = true
                self?.searchResultEmptyView.stopAnimation()
                return items
            }
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$reloadItem)
            .filter { $0.isNotNull }
            .subscribe(onNext: { [weak self] indexPath in
                guard let indexPath = indexPath else { return }
                self?.collectionView.reloadItems(at: [indexPath])
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isEmpty)
            .filter { $0.isNotNull }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchResultEmptyView.isHidden = false
                self?.searchResultEmptyView.playAnimation()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertContents)
            .filter { $0.isNotNull }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] content in
                self?.showAlert(title: content?.title, message: content?.message)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
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
