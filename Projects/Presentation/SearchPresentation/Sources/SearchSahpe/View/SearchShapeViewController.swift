//
//  SearchShapeViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

public final class SearchShapeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchShapeAdapter?
    
    public static func create(with reactor: SearchShapeReactor) -> SearchShapeViewController {
        let viewController = SearchShapeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let reactor = reactor {
            adapter = SearchShapeAdapter(
                collectionView: collectionView,
                dataSource: reactor
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchShapeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension SearchShapeViewController {
    private func bindAction(_ reactor: SearchShapeReactor) {
        
    }
    
    private func bindState(_ reactor: SearchShapeReactor) {
        
    }
    
    private func bindAdapter(_ reactor: SearchShapeReactor) {
        
    }
}

// MARK: - Layout
extension SearchShapeViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
    }
    
    private func setupSubviewLayout() {
        
    }
}
