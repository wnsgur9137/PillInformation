//
//  BookmarkAdapter.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public protocol BookmarkAdapterDataSource: AnyObject {
    func numberOfRowsIn(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath)
}

public protocol BookmarkAdapterDelegate: AnyObject {
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

public final class BookmarkAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var dataSource: BookmarkAdapterDataSource?
    private weak var delegate: BookmarkAdapterDelegate?
    
    init(tableView: UITableView, 
         dataSource: BookmarkAdapterDataSource,
         delegate: BookmarkAdapterDelegate) {
        tableView.isScrollEnabled = false
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension BookmarkAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsIn(section: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
}

// MARK: - UITableView Delegate
extension BookmarkAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
}
