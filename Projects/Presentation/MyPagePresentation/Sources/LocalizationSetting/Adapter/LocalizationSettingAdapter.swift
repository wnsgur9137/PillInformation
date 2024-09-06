//
//  LocalizationSettingAdapter.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LocalizationSettingDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> (title: String, isChecked: Bool)?
}

protocol LocalizationSettingDelegate: AnyObject {
    
}

final class LocalizationSettingAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: LocalizationSettingDataSource?
    private weak var delegate: LocalizationSettingDelegate?
    let didSelectRow: PublishRelay<IndexPath> = .init()
    
    init(tableView: UITableView,
         dataSource: LocalizationSettingDataSource,
         delegate: LocalizationSettingDelegate) {
        tableView.register(LocalizationSettingCell.self, forCellReuseIdentifier: LocalizationSettingCell.identifier)
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension LocalizationSettingAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocalizationSettingCell.identifier, for: indexPath) as? LocalizationSettingCell else { return .init() }
        guard let data = dataSource?.cellForItem(at: indexPath) else { return cell }
        cell.configure(title: data.title, isChecked: data.isChecked)
        return cell
    }
}

// MARK: - UITableView Delegate
extension LocalizationSettingAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.accept(indexPath)
    }
}
