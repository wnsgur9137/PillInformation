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
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Bookmark"
        label.textColor = Constants.Color.systemLabel
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
    private lazy var bookmarkTableViewHeight: CGFloat = 50.0
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: BookmarkReactor) -> BookmarkViewController {
        let viewController = BookmarkViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let reactor = reactor {
            adapter = BookmarkAdapter(tableView: bookmarkTableView,
                                      dataSource: reactor,
                                      delegate: self)
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
}

// MARK: - Methods
extension BookmarkViewController {
    
}

// MARK: - Binding
extension BookmarkViewController {
    private func bindAction(_ reactor: BookmarkReactor) {
        
    }
    
    private func bindState(_ reactor: BookmarkReactor) {
        
    }
}

// MARK: - BookmarkAdapter Delegate
extension BookmarkViewController: BookmarkAdapterDelegate {
    public func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return bookmarkTableViewHeight
    }
}

// MARK: - Layout
extension BookmarkViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(searchTextFieldView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { contentView in
            contentView.addItem(testLabel)
            contentView.addItem(bookmarkTableView)
            contentView.addItem(footerView)
                .marginTop(24.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin
            .left().right().bottom().top(view.safeAreaInsets.top)
        searchTextFieldView.pin
            .left(24.0)
            .right(24.0)
            .height(48.0)
        searchTextFieldView.flex.layout()
        
        scrollView.pin
            .top(to: searchTextFieldView.edge.bottom).marginTop(10.0)
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
