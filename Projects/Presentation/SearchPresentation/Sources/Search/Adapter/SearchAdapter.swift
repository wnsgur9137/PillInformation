//
//  SearchAdapter.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public protocol SearchAdapterDataSource: AnyObject {
    func numberOfItemsIn(section: Int) -> Int
    func cellForItem(at indexPath: IndexPath) -> String
}

public protocol SearchAdapterDelegate: AnyObject {
    
}

public final class SearchAdapter: NSObject {
    private let collectionView: UICollectionView
    private weak var dataSource: SearchAdapterDataSource?
    private weak var delegate: SearchAdapterDelegate?
    
    init(collectionView: UICollectionView,
         dataSource: SearchAdapterDataSource,
         delegate: SearchAdapterDelegate) {
        collectionView.register(SearchRecentCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecentCollectionViewCell.identifier)
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsIn(section: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecentCollectionViewCell.identifier, for: indexPath) as? SearchRecentCollectionViewCell else { return .init() }
        guard let text = dataSource?.cellForItem(at: indexPath) else { return cell }
        cell.configure(text: text)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension SearchAdapter: UICollectionViewDelegate {
    
}
