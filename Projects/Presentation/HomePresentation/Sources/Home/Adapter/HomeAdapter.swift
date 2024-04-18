//
//  HomeAdapter.swift
//  Home
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public protocol HomeAdapterDataSource: AnyObject {
    func numberOfRowsIn(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> NoticeModel?
}

public protocol HomeAdapterDelegate: AnyObject {
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

public final class HomeAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var dataSource: HomeAdapterDataSource?
    private weak var delegate: HomeAdapterDelegate?
    
    init(tableView: UITableView,
         dataSource: HomeAdapterDataSource,
         delegate: HomeAdapterDelegate) {
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
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
extension HomeAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsIn(section: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return .init() }
        guard let data = dataSource?.cellForRow(at: indexPath) else {
            cell.configure(title: "TEST")
            return cell
        }
        cell.configure(title: data.title)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
}
