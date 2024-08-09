//
//  HomeNoticeAdapter.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import BasePresentation

public protocol HomeNoticeDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> NoticeModel?
}

public protocol HomeNoticeDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

public final class HomeNoticeAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: HomeNoticeDataSource?
    private weak var delegate: HomeNoticeDelegate?
    let didSelectRow: PublishRelay<IndexPath> = .init()
    
    public init(tableView: UITableView,
                dataSource: HomeNoticeDataSource,
                delegate: HomeNoticeDelegate) {
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension HomeNoticeAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
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
extension HomeNoticeAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.accept(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
}
