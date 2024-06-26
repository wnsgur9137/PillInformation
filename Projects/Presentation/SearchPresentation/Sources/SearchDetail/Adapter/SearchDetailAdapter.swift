//
//  SearchDetailAdapter.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/13/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

import BasePresentation

public protocol SearchDetailDataSource: AnyObject {
    func numberOfSection() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewForHeader(in section: Int) -> URL?
    func cellForRow(at indexPath: IndexPath) -> (pillInfoType: PillInfoType, name: String?, value: String?)?
    func hasPillDescription() -> Bool
}

public protocol SearchDetailDelegate: AnyObject {
//    func didSelectSection(at section: Int)
//    func didSelectRow(at indexPath: IndexPath)
    func heightForHeader(in section: Int) -> CGFloat
    func heightForFooter(in section: Int) -> CGFloat
    func scrollViewDidScroll(_ contentOffset: CGPoint)
}

public final class SearchDetailAdapter: NSObject {
    private let tableView: UITableView
    private weak var dataSource: SearchDetailDataSource?
    private weak var delegate: SearchDetailDelegate?
    let didSelectSection = PublishSubject<Int>()
    let didSelectRow = PublishSubject<IndexPath>()
    
    init(tableView: UITableView,
         dataSource: SearchDetailDataSource,
         delegate: SearchDetailDelegate) {
        tableView.register(SearchDetailTableViewImageHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchDetailTableViewImageHeaderView.identifier)
        tableView.register(SearchDetailTableViewCell.self, forCellReuseIdentifier: SearchDetailTableViewCell.identifier)
        tableView.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: TableFooterView.identifier)
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func makeImageHeaderView(_ section: Int) -> SearchDetailTableViewImageHeaderView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchDetailTableViewImageHeaderView.identifier) as? SearchDetailTableViewImageHeaderView else { return nil }
        guard let imageURL = dataSource?.viewForHeader(in: section) else { return headerView }
        headerView.imageView.kf.setImage(with: imageURL)
        headerView.contentView.layoutMargins = .zero
        headerView.imageView.rx.tapGesture()
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.didSelectSection.onNext(section)
            })
            .disposed(by: headerView.disposeBag)
        return headerView
    }
}

// MARK: - UITableView DataSource
extension SearchDetailAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSection() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return makeImageHeaderView(section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailTableViewCell.identifier, for: indexPath) as? SearchDetailTableViewCell else { return .init() }
        guard let data = dataSource?.cellForRow(at: indexPath),
              let name = data.name else { return cell }
        cell.configure(data.pillInfoType, name: name, value: data.value)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataSource?.hasPillDescription() ?? false {
            guard section == 2 else { return nil }
        } else {
            guard section == 1 else { return nil }
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: TableFooterView.identifier) as? TableFooterView
    }
}

// MARK: - UITableView Delegate
extension SearchDetailAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.onNext(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeader(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if dataSource?.hasPillDescription() ?? false {
            guard section == 2 else { return 0 }
        } else {
            guard section == 1 else { return 0 }
        }
        return delegate?.heightForFooter(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIScrollView Delegate
extension SearchDetailAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView.contentOffset)
    }
}
