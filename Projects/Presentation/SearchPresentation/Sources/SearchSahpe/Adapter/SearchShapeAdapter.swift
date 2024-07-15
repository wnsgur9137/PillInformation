//
//  SearchAdapter.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import BasePresentation

public protocol SearchShapeAdapterDataSource: AnyObject {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func colorCellForItem(at item: Int) -> SearchColorItems
    func shapeCellForItem(at item: Int) -> SearchShapeItems
    func lineCellForItem(at item: Int) -> SearchLineItems
}

public final class SearchShapeAdapter: NSObject {
    private let collectionView: UICollectionView
    private weak var dataSource: SearchShapeAdapterDataSource?
    let didSelectItem: PublishSubject<IndexPath> = .init()
    
    public init(collectionView: UICollectionView, 
                dataSource: SearchShapeAdapterDataSource) {
        collectionView.register(SearchShapeCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchShapeCollectionViewHeaderView.identifier)
        collectionView.register(SearchShapeCollectionViewCell.self, forCellWithReuseIdentifier: SearchShapeCollectionViewCell.identifier)
        collectionView.register(PrintCollectionViewCell.self, forCellWithReuseIdentifier: PrintCollectionViewCell.identifier)
        
        self.collectionView = collectionView
        self.dataSource = dataSource
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchShapeAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchShapeCollectionViewHeaderView.identifier, for: indexPath) as? SearchShapeCollectionViewHeaderView,
              let section = SearchShapeCollectionViewSecton(rawValue: indexPath.section) else { return .init() }
        
        switch section {
        case .color: headerView.configure(Constants.SearchShape.color)
        case .shape: headerView.configure(Constants.SearchShape.shape)
        case .line: headerView.configure(Constants.SearchShape.line)
        case .print: headerView.configure(Constants.SearchShape.print)
        }
        
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SearchShapeCollectionViewSecton(rawValue: indexPath.section) else { return .init() }
        
        if section == .print {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrintCollectionViewCell.identifier, for: indexPath) as? PrintCollectionViewCell else { return .init() }
            cell.textFieldDeleagte(self)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchShapeCollectionViewCell.identifier, for: indexPath) as? SearchShapeCollectionViewCell else { return .init() }
        
        switch section {
        case .shape:
            guard let shape = dataSource?.shapeCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(shape)
        case .color:
            guard let color = dataSource?.colorCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(color)
        case .line:
            guard let line = dataSource?.lineCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(line)
        case .print: return .init()
        }
        
        cell.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                cell.isSelected = !cell.isSelected
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchShapeAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.onNext(indexPath)
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension SearchShapeAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = SearchShapeCollectionViewSecton(rawValue: indexPath.section) else { return CGSize() }
        switch section {
        case .shape: return CGSize(width: 80.0, height: 80.0)
        case .color: fallthrough
        case .line: return CGSize(width: 56.0, height: 56.0)
        case .print: return CGSize(width: collectionView.bounds.width, height: 120.0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    }
}

// MARK: - UITextField Delegate
extension SearchShapeAdapter: UITextFieldDelegate {
    
}
