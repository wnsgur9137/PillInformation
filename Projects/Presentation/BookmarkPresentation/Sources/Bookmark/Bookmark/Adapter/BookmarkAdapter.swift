//
//  BookmarkAdapter.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

import BasePresentation

public protocol BookmarkAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> PillInfoModel
}

public protocol BookmarkAdapterDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

public final class BookmarkAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var dataSource: BookmarkAdapterDataSource?
    private weak var delegate: BookmarkAdapterDelegate?
    let didSelectRow = PublishSubject<IndexPath>()
    let didSelectBookmark = PublishSubject<IndexPath>()
    let deleteRow = PublishSubject<IndexPath>()
    
    init(tableView: UITableView, 
         dataSource: BookmarkAdapterDataSource,
         delegate: BookmarkAdapterDelegate) {
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell,
              let data = dataSource?.cellForRow(at: indexPath) else { return .init() }
        cell.configure(data)
        cell.bookmarkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelectBookmark.onNext(indexPath)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableView Delegate
extension BookmarkAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.onNext(indexPath)
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
            deleteRow.onNext(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
