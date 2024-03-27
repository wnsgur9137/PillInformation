//
//  AlarmAdapter.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

protocol AlarmAdapterDataSource: AnyObject {
    func numberOfRowsIn(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath)
}

protocol AlarmAdapterDelegate: AnyObject {
    func didSelectRow(at indexPath: IndexPath)
}

final class AlarmAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: AlarmAdapterDataSource?
    private weak var delegate: AlarmAdapterDelegate?
    
    init(tableView: UITableView, 
         dataSource: AlarmAdapterDataSource?,
         delegate: AlarmAdapterDelegate?) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension AlarmAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsIn(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
}

// MARK: - UITableView Delegate
extension AlarmAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
