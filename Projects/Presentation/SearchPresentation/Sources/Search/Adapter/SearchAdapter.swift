//
//  SearchAdapter.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

import BasePresentation

public protocol SearchAdapterDataSource: AnyObject {
    func collectionViewNumberOfItems(in section: Int) -> Int
    func collectionViewCellForItem(at indexPath: IndexPath) -> String
    
    func tableViewNumberOfRows(in section: Int) -> Int
    func tableViewCellForRow(at indexPath: IndexPath) -> String
}

public final class SearchAdapter: NSObject {
    private let collectionView: UICollectionView
    private let tableView: UITableView
    private let textField: UITextField
    private weak var dataSource: SearchAdapterDataSource?
    let shouldReturn = PublishSubject<String?>()
    let didSelectCollectionViewItem = PublishSubject<IndexPath>()
    let didSelectTableViewRow = PublishSubject<IndexPath>()
    let didSelectTableViewDeleteButton = PublishSubject<IndexPath>()
    let didSelectTableViewDeleteAllButton = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init(collectionView: UICollectionView,
         tableView: UITableView,
         textField: UITextField,
         dataSource: SearchAdapterDataSource) {
        collectionView.register(RecommendKeywordCollectionViewCell.self, forCellWithReuseIdentifier: RecommendKeywordCollectionViewCell.identifier)
        tableView.register(RecentTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentTableViewHeaderView.identifier)
        tableView.register(RecentTableViewCell.self, forCellReuseIdentifier: RecentTableViewCell.identifier)
        self.collectionView = collectionView
        self.tableView = tableView
        self.textField = textField
        self.dataSource = dataSource
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.collectionViewNumberOfItems(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendKeywordCollectionViewCell.identifier, for: indexPath) as? RecommendKeywordCollectionViewCell else { return .init() }
        guard let text = dataSource?.collectionViewCellForItem(at: indexPath) else { return cell }
        cell.configure(text: text)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCollectionViewItem.onNext(indexPath)
    }
}

extension SearchAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = dataSource?.collectionViewCellForItem(at: indexPath) else { return CGSize() }
        let textSize = (text as NSString).size(withAttributes: [
            NSAttributedString.Key.font: Constants.Font.suiteMedium(20.0)
        ])
        let width = ceil(textSize.width) + 24.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    }
}

// MARK: - UITableView DataSource
extension SearchAdapter: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.tableViewNumberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentTableViewHeaderView.identifier) as? RecentTableViewHeaderView else { return nil }
        view.deleteAllButton.rx.tap
            .bind(to: didSelectTableViewDeleteAllButton)
            .disposed(by: view.disposeBag)
        return view
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else { return .init() }
        guard let title = dataSource?.tableViewCellForRow(at: indexPath) else { return cell }
        cell.configure(text: title)
        cell.deleteButton.rx.tap
            .map { indexPath }
            .bind(to: didSelectTableViewDeleteButton)
            .disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableView Delegate
extension SearchAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTableViewRow.onNext(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextField Delegate
extension SearchAdapter: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn.onNext(textField.text)
        return true
    }
}
