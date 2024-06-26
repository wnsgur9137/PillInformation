//
//  NoticeDetailAdapter.swift
//  Home
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

public protocol NoticeDetailAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> NoticeModel?
}

public final class NoticeDetailAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: NoticeDetailAdapterDataSource?
    let didSelectRow = PublishSubject<IndexPath>()
    
    init(tableView: UITableView,
         dataSource: NoticeDetailAdapterDataSource) {
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        tableView.isScrollEnabled = false
        self.tableView = tableView
        self.dataSource = dataSource
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension NoticeDetailAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3, dataSource?.numberOfRows(in: section) ?? 0)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return .init() }
        guard let data = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(title: data.title)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableView Delegate
extension NoticeDetailAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.onNext(indexPath)
    }
}
