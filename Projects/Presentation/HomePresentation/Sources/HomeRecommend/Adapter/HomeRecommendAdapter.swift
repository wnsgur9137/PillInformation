//
//  HomeRecommendAdapter.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import BasePresentation

public protocol HomeRecommendDataSource: AnyObject {
    func numberOfSection() -> Int
    func numberOfItems(in section: Int) -> Int
    func recommendSecitonItem(at indexPath: IndexPath) -> PillInfoModel?
    func headerTitle(at section: Int) -> String?
}

public protocol HomeRecommendDelegate: AnyObject {
    
}

public final class HomeRecommendAdapter: NSObject {
    private let scrollView: UIScrollView
    private let collectionView: UICollectionView
    private weak var dataSource: HomeRecommendDataSource?
    private weak var delegate: HomeRecommendDelegate?
    let didSelectItem: PublishRelay<IndexPath> = .init()
    
    public init(scrollView: UIScrollView,
                collectionView: UICollectionView,
                dataSource: HomeRecommendDataSource,
                delegate: HomeRecommendDelegate) {
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.register(HomeRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeRecommendHeaderView.identifier)
        self.scrollView = scrollView
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        
        self.scrollView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

// MARK: - ScrollView Delegate
extension HomeRecommendAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        
    }
}

// MARK: - UICollectionView DataSource
extension HomeRecommendAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSection() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return .init() }
        guard let data = dataSource?.recommendSecitonItem(at: indexPath) else { return cell }
        cell.configure(data)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return .init() }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeRecommendHeaderView.identifier, for: indexPath) as? HomeRecommendHeaderView else { return .init() }
        guard let title = dataSource?.headerTitle(at: indexPath.section) else { return view }
        view.configure(title: title)
        return view
    }
}

// MARK: - UICollectionView Delegate
extension HomeRecommendAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.accept(indexPath)
    }
}
