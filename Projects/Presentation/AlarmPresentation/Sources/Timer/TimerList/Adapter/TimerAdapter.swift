//
//  TimerAdapter.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol TimerAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> TimerModel?
    func update(_ timerModel: TimerModel)
}

public protocol TimerAdapterDelegate: AnyObject {
    func didSelectAddButton()
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func heightForHeader(in section: Int) -> CGFloat
    func deleteRow(at indexPath: IndexPath)
}

public final class TimerAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: TimerAdapterDataSource?
    private weak var delegate: TimerAdapterDelegate?
    
    init(tableView: UITableView,
         dataSource: TimerAdapterDataSource,
         delegate: TimerAdapterDelegate) {
        tableView.register(TimerTableHeaderView.self, forHeaderFooterViewReuseIdentifier: TimerTableHeaderView.identifier)
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension TimerAdapter: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return .init() }
        guard let data = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(data)
        cell.completedRelay
            .bind(onNext: { [weak self] timerModel in
                self?.dataSource?.update(timerModel)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimerTableHeaderView.identifier) as? TimerTableHeaderView else { return nil }
        if section == 0 {
            headerView.addButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.didSelectAddButton()
                })
                .disposed(by: headerView.disposeBag)
        }
        headerView.configure(isOperationHeader: section == 0)
        return headerView
    }
}

// MARK: - UITableView Delegate
extension TimerAdapter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            delegate?.deleteRow(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeader(in: section) ?? 0
    }
}
