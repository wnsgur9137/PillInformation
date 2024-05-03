//
//  AlarmAdapter.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlarmAdapterDataSource: AnyObject {
    func numberOfRowsIn(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> AlarmModel
}

protocol AlarmAdapterDelegate: AnyObject {
    func didSelectAddButton()
    func didSelectToggleButton(at indexPath: IndexPath)
    func didSelectWeekButton(at indexPath: IndexPath, button: AlarmAdapter.WeekButton)
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func heightForHeader(in section: Int) -> CGFloat
    func deleteRow(at indexPath: IndexPath)
}

final class AlarmAdapter: NSObject {
    enum WeekButton: Int {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    private let tableView: UITableView
    private weak var dataSource: AlarmAdapterDataSource?
    private weak var delegate: AlarmAdapterDelegate?
    
    init(tableView: UITableView, 
         dataSource: AlarmAdapterDataSource?,
         delegate: AlarmAdapterDelegate?) {
        tableView.register(AlarmTableHeaderView.self, forHeaderFooterViewReuseIdentifier: AlarmTableHeaderView.identifier)
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsIn(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return .init() }
        guard let data = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(data)
        cell.toggleButton.rx.tapGesture()
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didSelectToggleButton(at: indexPath)
            })
            .disposed(by: cell.disposeBag)
        
        let weekButtons: [UIButton] = [
            cell.weekSelectionView.sundayButton,
            cell.weekSelectionView.mondayButton,
            cell.weekSelectionView.tuesdayButton,
            cell.weekSelectionView.wednesdayButton,
            cell.weekSelectionView.thursdayButton,
            cell.weekSelectionView.fridayButton,
            cell.weekSelectionView.saturdayButton
        ]
        
        weekButtons.enumerated().forEach { index, button in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let buttonType = WeekButton(rawValue: index) else { return }
                    self?.delegate?.didSelectWeekButton(at: indexPath, button: buttonType)
                    button.isSelected = !button.isSelected
                })
                .disposed(by: cell.disposeBag)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AlarmTableHeaderView.identifier) as? AlarmTableHeaderView else { return nil }
        headerView.addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.didSelectAddButton()
            })
            .disposed(by: headerView.disposeBag)
        return headerView
    }
}

// MARK: - UITableView Delegate
extension AlarmAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            delegate?.deleteRow(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeader(in: section) ?? 0
    }
}
