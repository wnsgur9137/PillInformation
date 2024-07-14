//
//  MyPageAdapter.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

import BasePresentation

public protocol MyPageAdapterDataSource: AnyObject {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> String
}

public final class MyPageAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: MyPageAdapterDataSource?
    let didSelectRow = PublishSubject<IndexPath>()
    
    init(tableView: UITableView, 
         dataSource: MyPageAdapterDataSource) {
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        self.tableView = tableView
        self.dataSource = dataSource
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MyPageAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { return .init() }
        guard let title = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(title: title)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return Constants.MyPage.setting
        case 1: return Constants.MyPage.policy
        case 2: return Constants.MyPage.userInfo
        default: return nil
        }
    }
}

extension MyPageAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.onNext(indexPath)
    }
}
