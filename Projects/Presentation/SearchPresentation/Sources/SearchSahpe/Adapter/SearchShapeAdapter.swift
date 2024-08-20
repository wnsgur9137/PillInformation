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
    func colorCellForItem(at item: Int) -> (item: SearchColorItems, isSelected: Bool)
    func shapeCellForItem(at item: Int) -> (item: SearchShapeItems, isSelected: Bool)
    func lineCellForItem(at item: Int) -> (item: SearchLineItems, isSelected: Bool)
}

public final class SearchShapeAdapter: NSObject {
    private let collectionView: UICollectionView
    private weak var dataSource: SearchShapeAdapterDataSource?
    let didSelectItem: PublishSubject<(section: SearchShapeCollectionViewSecton, isSelected: Bool, value: String?)> = .init()
    let didSelectSearchButton: PublishSubject<Void> = .init()
    
    public init(collectionView: UICollectionView,
                dataSource: SearchShapeAdapterDataSource) {
        collectionView.register(SearchShapeCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchShapeCollectionViewHeaderView.identifier)
        collectionView.register(SearchShapeCollectionViewCell.self, forCellWithReuseIdentifier: SearchShapeCollectionViewCell.identifier)
        collectionView.register(CodeCollectionViewCell.self, forCellWithReuseIdentifier: CodeCollectionViewCell.identifier)
        collectionView.register(SearchShapeCollectionSearchCell.self, forCellWithReuseIdentifier: SearchShapeCollectionSearchCell.identifier)
        
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
        case .color: headerView.configure(Constants.Search.color)
        case .shape: headerView.configure(Constants.Search.shape)
        case .line: headerView.configure(Constants.Search.line)
        case .code: headerView.configure(Constants.Search.print)
        case .searchView: return .init()
        }
        
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SearchShapeCollectionViewSecton(rawValue: indexPath.section) else { return .init() }
        
        if section == .code {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CodeCollectionViewCell.identifier, for: indexPath) as? CodeCollectionViewCell else { return .init() }
            cell.textFieldDeleagte(self)
            return cell
        }
        
        if section == .searchView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchShapeCollectionSearchCell.identifier, for: indexPath) as? SearchShapeCollectionSearchCell else { return .init() }
            cell.searchButton.rx.tap
                .bind(to: didSelectSearchButton)
                .disposed(by: cell.disposeBag)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchShapeCollectionViewCell.identifier, for: indexPath) as? SearchShapeCollectionViewCell else { return .init() }
        
        switch section {
        case .shape:
            guard let shapeData = dataSource?.shapeCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(shapeData.item, isSelected: shapeData.isSelected)
        case .color:
            guard let colorData = dataSource?.colorCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(colorData.item, isSelected: colorData.isSelected)
        case .line:
            guard let lineData = dataSource?.lineCellForItem(at: indexPath.item) else { return .init() }
            cell.configure(lineData.item, isSelected: lineData.isSelected)
        default: return .init()
        }
        
        cell.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                cell.isSelectedCell = !cell.isSelectedCell
                self.didSelectItem.onNext((section, cell.isSelectedCell, cell.content))
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchShapeAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        case .code: return CGSize(width: collectionView.bounds.width, height: 60.0)
        case .searchView: return CGSize(width: collectionView.bounds.width, height: 180.0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = SearchShapeCollectionViewSecton(rawValue: section),
              section != .searchView else { return .init() }
        return CGSize(width: collectionView.bounds.width, height: 80.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    }
}

// MARK: - UITextField Delegate
extension SearchShapeAdapter: UITextFieldDelegate {
    
}
