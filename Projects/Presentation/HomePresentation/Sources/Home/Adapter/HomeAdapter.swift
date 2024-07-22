//
//  HomeAdapter.swift
//  Home
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

import BasePresentation

public protocol HomeAdapterDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> NoticeModel?
    func numberOfItems(in section: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> PillInfoModel
}

public protocol HomeAdapterDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

public final class HomeAdapter: NSObject {
    
    private let tableView: UITableView
    private let collectionView: UICollectionView
    private weak var dataSource: HomeAdapterDataSource?
    private weak var delegate: HomeAdapterDelegate?
    let didSelectRow = PublishSubject<IndexPath>()
    let didSelectItem = PublishSubject<IndexPath>()
    
    init(tableView: UITableView,
         collectionView: UICollectionView,
         dataSource: HomeAdapterDataSource,
         delegate: HomeAdapterDelegate) {
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        tableView.isScrollEnabled = false
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        self.tableView = tableView
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

// MARK: - UITableView DataSource
extension HomeAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
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
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow.onNext(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
}

// MARK: - UICollectionView DataSource
extension HomeAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return .init() }
        guard let data = dataSource?.cellForItem(at: indexPath) else { return cell }
        cell.configure(data)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension HomeAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.onNext(indexPath)
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension HomeAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
