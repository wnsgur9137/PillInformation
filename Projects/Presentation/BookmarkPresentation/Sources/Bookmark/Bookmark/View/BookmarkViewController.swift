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
import FlexLayout
import PinLayout

import BasePresentation

public final class BookmarkViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let searchTextFieldView = SearchTextFieldView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Bookmark.bookmark
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    private let bookmarkTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    private var adapter: BookmarkAdapter?
    public var disposeBag = DisposeBag()
    private lazy var bookmarkTableViewHeight: CGFloat = 120.0
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: BookmarkReactor) -> BookmarkViewController {
        let viewController = BookmarkViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        rootContainerView.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = BookmarkAdapter(tableView: bookmarkTableView,
                                      dataSource: reactor,
                                      delegate: self)
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: BookmarkReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showSingleAlert(title: String, message: String?) {
        var messageAlertText: AlertText?
        if let message {
            messageAlertText = AlertText(text: message)
        }
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: .init(text: title),
                message: messageAlertText,
                confirmButtonInfo: .init(title: Constants.confirm)
            )
    }
}

// MARK: - Methods
extension BookmarkViewController {
    
}

// MARK: - Binding
extension BookmarkViewController {
    private func bindAction(_ reactor: BookmarkReactor) {
        searchTextFieldView.shapeSearchButton.rx.tap
            .map { Reactor.Action.didTapSearchShapeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.loadBookmarkPills }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: BookmarkReactor) {
        reactor.pulse(\.$bookmarkPillCount)
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                let height = (bookmarkTableViewHeight * CGFloat(count ?? 0)) + 30
                self.bookmarkTableView.flex.height(height)
                self.bookmarkTableView.reloadData()
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
    
    private func bindAdapter(_ reactor: BookmarkReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectBookmark
            .map { indexPath in
                Reactor.Action.didSelectBookmark(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.deleteRow
            .map { indexPath in
                Reactor.Action.deleteRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - BookmarkAdapter Delegate
extension BookmarkViewController: BookmarkAdapterDelegate {
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return bookmarkTableViewHeight
    }
}

// MARK: - Layout
extension BookmarkViewController {
    private func setupLayout() {
        view.addSubview(searchTextFieldView)
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { contentView in
            contentView.addItem(titleLabel)
                .margin(24.0)
            contentView.addItem(bookmarkTableView)
                .minHeight(40.0)
            contentView.addItem(footerView)
                .marginTop(24.0)
        }
    }
    
    private func setupSubviewLayout() {
        searchTextFieldView.pin.left().right().top(view.safeAreaInsets.top)
        searchTextFieldView.flex.layout()
        rootContainerView.pin.left().right().bottom(view.safeAreaInsets.bottom).top(to: searchTextFieldView.edge.bottom)
        
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
