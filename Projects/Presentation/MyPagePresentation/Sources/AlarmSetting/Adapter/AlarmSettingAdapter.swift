//
//  AlarmSettingAdapter.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

public protocol AlarmSettingAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> AlarmSettingCellInfo
}

public final class AlarmSettingAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: AlarmSettingAdapterDataSource?
    private let disposeBag = DisposeBag()
    let didSelectSwitch = PublishSubject<IndexPath>()
    
    public init(tableView: UITableView, 
                dataSource: AlarmSettingAdapterDataSource?) {
        tableView.register(AlarmSettingTableViewCell.self, forCellReuseIdentifier: AlarmSettingTableViewCell.identifier)
        self.tableView = tableView
        self.dataSource = dataSource
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension AlarmSettingAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmSettingTableViewCell.identifier, for: indexPath) as? AlarmSettingTableViewCell else { return .init() }
        guard let contents = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(contents)
        
        cell.toggleButton.rx.isOn
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.didSelectSwitch.onNext(indexPath)
            })
            .disposed(by: disposeBag)
        return cell
    }
}

// MARK: - UITableView Delegate
extension AlarmSettingAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
