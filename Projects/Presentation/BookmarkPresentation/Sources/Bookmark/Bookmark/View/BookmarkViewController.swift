//
//  BookmarkViewController.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import FlexLayout
import PinLayout

import BasePresentation

public final class BookmarkViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let bookmarkHeaderView = BookmarkHeaderView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emptyBookmarkView = EmptyBookmarkView()
    private let bookmarkTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookmarkTableHeaderView.self, forHeaderFooterViewReuseIdentifier: BookmarkTableHeaderView.identifier)
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        return tableView
    }()
    private let footerView = FooterView()
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private lazy var bookmarkTableViewHeight: CGFloat = 120.0
    private lazy var bookmarkTableHeaderViewHeight: CGFloat = 52.0
    
    private let didSelectBookmarkButton: PublishRelay<IndexPath> = .init()
    private let didSelectDeleteAllButton: PublishRelay<Void> = .init()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: BookmarkReactor) -> BookmarkViewController {
        let viewController = BookmarkViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        rootContainerView.backgroundColor = Constants.Color.background
        setupLayout()
        bookmarkTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: BookmarkReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showSingleAlert(title: String, 
                                 message: String?,
                                 action: @escaping () -> Void = {}) {
        var messageAlertText: AlertText?
        if let message {
            messageAlertText = AlertText(text: message)
        }
        AlertViewer()
            .showSingleButtonAlert(
                in: view,
                title: .init(text: title),
                message: messageAlertText,
                confirmButtonInfo: .init(title: Constants.confirm, action: action)
            )
    }
    
    private func setupEmptyBookmarkView(_ dataCount: Int) {
        let isEmptyData = dataCount == 0
        emptyBookmarkView.flex.display(isEmptyData ? .flex : .none)
        isEmptyData ? emptyBookmarkView.playAnimation() : emptyBookmarkView.stopAnimation()
    }
    
    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<BookmarkTableViewSectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<BookmarkTableViewSectionModel> { _, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell else { return .init() }
            cell.configure(item)
            cell.bookmarkButton.rx.tap
                .map { return indexPath }
                .bind(to: self.didSelectBookmarkButton)
                .disposed(by: cell.disposeBag)
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        return dataSource
    }
}

// MARK: - Binding
extension BookmarkViewController {
    private func bindAction(_ reactor: BookmarkReactor) {
        rx.viewWillAppear
            .map { Reactor.Action.loadBookmarkPills }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkHeaderView.searchTextFieldView.searchTextField.rx.text.changed
            .filter { $0 != nil }
            .map { text in Reactor.Action.filtered(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkTableView.rx.itemSelected
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkTableView.rx.itemDeleted
            .map { indexPath in
                Reactor.Action.deleteRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectBookmarkButton
            .map { indexPath in
                Reactor.Action.didSelectBookmark(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectDeleteAllButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showSingleAlert(title: Constants.Bookmark.askDeleteAll, message: nil, action: {
                    Observable.just(Void())
                        .map { Reactor.Action.deleteAll }
                        .bind(to: reactor.action)
                        .disposed(by: self.disposeBag)
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: BookmarkReactor) {
        reactor.pulse(\.$pills)
            .bind(to: bookmarkTableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$bookmarkPillCount)
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] count in
                guard let self = self,
                      let count = count else { return }
                self.bookmarkTableView.flex.display(count == 0 ? .none : .flex)
                let height = (bookmarkTableViewHeight * CGFloat(count)) + 30 + bookmarkTableHeaderViewHeight
                self.bookmarkTableView.flex.height(height)
                self.bookmarkTableView.reloadData()
                self.setupEmptyBookmarkView(count)
                self.updateSubviewLayout()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertContent)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] contents in
                guard let title = contents?.title else { return }
                self?.showSingleAlert(title: title, message: contents?.message)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView Delegate
extension BookmarkViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookmarkTableHeaderView.identifier) as? BookmarkTableHeaderView else { return .init() }
        view.deleteButton.rx.tap
            .bind(to: didSelectDeleteAllButton)
            .disposed(by: view.disposeBag)
        return view
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bookmarkTableViewHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return bookmarkTableHeaderViewHeight
    }
}

// MARK: - Layout
extension BookmarkViewController {
    private func setupLayout() {
        view.addSubview(bookmarkHeaderView)
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.flex.backgroundColor(Constants.Color.skyBlueBackground)
        rootContainerView.flex.backgroundColor(Constants.Color.background)
        
        contentView.flex
            .backgroundColor(Constants.Color.background)
            .define { contentView in
                contentView.addItem(bookmarkTableView)
                    .minHeight(40.0)
                    .backgroundColor(Constants.Color.background)
                contentView.addItem(emptyBookmarkView)
                    .minHeight(50%)
                    .display(.none)
                contentView.addItem(footerView)
                    .marginTop(24.0)
            }
    }
    
    private func setupSubviewLayout() {
        bookmarkHeaderView.pin.left().right().top(view.safeAreaInsets.top)
        bookmarkHeaderView.flex.layout(mode: .adjustHeight)
        rootContainerView.pin.left().right().bottom(view.safeAreaInsets.bottom).top(to: bookmarkHeaderView.edge.bottom)
        
        scrollView.pin
            .top()
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
        
        contentView.pin.top().horizontally()
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
