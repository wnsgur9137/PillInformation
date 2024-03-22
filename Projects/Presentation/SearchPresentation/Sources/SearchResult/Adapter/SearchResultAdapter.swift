//
//  SearchResultAdapter.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public protocol SearchResultAdapterDataSource: AnyObject {
    func numberOfItemsIn(section: Int) -> Int
    func cellForItem(at: IndexPath) -> Data
}

public protocol SearchResultAdapterDelegate: AnyObject {
    
}

public final class SearchResultAdapter: NSObject {
    private let collectionView: UICollectionView
    private weak var dataSource: SearchResultAdapterDataSource?
    private weak var deleagte: SearchResultAdapterDelegate?
    
    init(collectionView: UICollectionView,
         dataSource: SearchResultAdapterDataSource,
         deleagte: SearchResultAdapterDelegate) {
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.deleagte = deleagte
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionView DataSource
extension SearchResultAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsIn(section: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return .init()
    }
}

// MARK: - UICollectionView Delegate
extension SearchResultAdapter: UICollectionViewDelegate {
    
}
