//
//  BookmarkAdapter.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import BasePresentation

public protocol BookmarkAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> PillInfoModel
}

public protocol BookmarkAdapterDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func heightForHeader() -> CGFloat
}

public final class BookmarkAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var dataSource: BookmarkAdapterDataSource?
    private weak var delegate: BookmarkAdapterDelegate?
    let didSelectRow: PublishRelay<IndexPath> = .init()
    let didSelectBookmark: PublishRelay<IndexPath> = .init()
    let deleteRow: PublishRelay<IndexPath> = .init()
    let didSelectDeleteAllButton: PublishRelay<Void> = .init()
    
    init(tableView: UITableView, 
         dataSource: BookmarkAdapterDataSource,
         delegate: BookmarkAdapterDelegate) {
        tableView.register(BookmarkTableHeaderView.self, forHeaderFooterViewReuseIdentifier: BookmarkTableHeaderView.identifier)
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        tableView.isScrollEnabled = false
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension BookmarkAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookmarkTableHeaderView.identifier) as? BookmarkTableHeaderView else { return .init() }
        view.deleteButton.rx.tap
            .bind(to: didSelectDeleteAllButton)
            .disposed(by: view.disposeBag)
        return view
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell,
              let data = dataSource?.cellForRow(at: indexPath) else { return .init() }
        cell.configure(data)
        cell.bookmarkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelectBookmark.accept(indexPath)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableView Delegate
extension BookmarkAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.accept(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            deleteRow.accept(indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeader() ?? 0
    }
}
