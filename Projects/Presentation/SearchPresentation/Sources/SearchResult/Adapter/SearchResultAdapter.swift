//
//  SearchResultAdapter.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift

public protocol SearchResultCollectionViewDataSource: AnyObject {
    func numberOfItems(in: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> PillInfoModel
}

public final class SearchResultAdapter: NSObject {
    private let collectionView: UICollectionView
    private let textField: UITextField
    private weak var collectionViewDataSource: SearchResultCollectionViewDataSource?
    
    let didSelectItem = PublishSubject<IndexPath>()
    let shouldReturn = PublishSubject<String?>()
    
    init(collectionView: UICollectionView,
         textField: UITextField,
         collectionViewDataSource: SearchResultCollectionViewDataSource) {
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        self.collectionView = collectionView
        self.textField = textField
        self.collectionViewDataSource = collectionViewDataSource
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        textField.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchResultAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource?.numberOfItems(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return .init() }
        guard let data = collectionViewDataSource?.cellForItem(at: indexPath) else { return cell }
        cell.showAnimatedGradientSkeleton()
        cell.configure(data)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchResultAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.onNext(indexPath)
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension SearchResultAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
    }
}

// MARK: - UITextField Delegate
extension SearchResultAdapter: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn.onNext(textField.text)
        return true
    }
}
