//
//  SearchAdapter.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public protocol SearchCollectionViewDataSource: AnyObject {
    func numberOfItemsIn(section: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> String
}

public protocol SearchCollectionViewDelegate: AnyObject {
    
}

public protocol SearchTextFieldDelegate: AnyObject {
    func shouldReturn(text: String?)
}

public final class SearchAdapter: NSObject {
    private let collectionView: UICollectionView
    private let textField: UITextField
    private weak var collectionViewDataSource: SearchCollectionViewDataSource?
    private weak var collectionViewDelegate: SearchCollectionViewDelegate?
    private weak var textFieldDelegate: SearchTextFieldDelegate?
    
    init(collectionView: UICollectionView,
         textField: UITextField,
         collectionViewDataSource: SearchCollectionViewDataSource,
         collectionViewDelegate: SearchCollectionViewDelegate,
         textFieldDelegate: SearchTextFieldDelegate) {
        collectionView.register(SearchRecentCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecentCollectionViewCell.identifier)
        self.collectionView = collectionView
        self.textField = textField
        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        self.textFieldDelegate = textFieldDelegate
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        textField.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource?.numberOfItemsIn(section: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecentCollectionViewCell.identifier, for: indexPath) as? SearchRecentCollectionViewCell else { return .init() }
        guard let text = collectionViewDataSource?.cellForItem(at: indexPath) else { return cell }
        cell.configure(text: text)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchAdapter: UICollectionViewDelegate {
    
}

// MARK: - UITextField Delegate
extension SearchAdapter: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDelegate?.shouldReturn(text: textField.text)
        return true
    }
}
