//
//  HomeRecommendViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import FlexLayout
import PinLayout

import BasePresentation

public final class HomeRecommendViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let footerView = FooterView()
    private lazy var loadingView = LoadingView()
    
    private lazy var recommendPillCollectionView: UICollectionView = {
        let layout = makeRecommendPillCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeRecommendHeaderView.identifier)
        collectionView.register(ShortcutButtonCell.self, forCellWithReuseIdentifier: ShortcutButtonCell.identifier)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeRecommendReactor) -> HomeRecommendViewController {
        let viewController = HomeRecommendViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadingView.show(in: self.view)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: HomeRecommendReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<RecommendCollectionViewSectionModel> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<RecommendCollectionViewSectionModel> { _, collectionView, indexPath, item in
            switch item {
            case .shortcut(let buttonInfo):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortcutButtonCell.identifier, for: indexPath) as? ShortcutButtonCell else { return .init() }
                cell.configure(buttonInfo)
                return cell
                
            case .recommendPills(let pill):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return .init() }
                cell.configure(pill)
                return cell
            }
        }
        
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return .init() }
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeRecommendHeaderView.identifier, for: indexPath) as? HomeRecommendHeaderView else { return .init() }
            view.configure(title: dataSource[indexPath.section].headerTitle)
            return view
        }
        
        return dataSource
    }
}

// MARK: - Bind
extension HomeRecommendViewController {
    private func bindAction(_ reactor: HomeRecommendReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.loadRecommendPills }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        recommendPillCollectionView.rx.itemSelected
            .map { indexPath in Reactor.Action.didSelectCollecitonViewItem(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeRecommendReactor) {
        reactor.pulse(\.$items)
            .bind(to: recommendPillCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$recommendPillCount)
            .bind(onNext: { recommendPillCount in
                /// height = recommendCell height * Cell count + Button section height
                let height = 180.0 * CGFloat(recommendPillCount) + 200.0
                UIView.animate(withDuration: 0.5,
                               animations: {
                    self.recommendPillCollectionView.flex.height(height)
                    self.recommendPillCollectionView.reloadData()
                    self.updateSubviewLayout()
                }, completion: { _ in
                    self.loadingView.hide()
                })
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension HomeRecommendViewController {
    private func makeRecommendPillCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            guard let section = HomeRecommendSection(rawValue: section) else { return nil }
            switch section {
            case .shortcut: return self.makeShortcutSection()
            case .pills: return self.makePillSection()
            }
        }
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: BackgroundDecorationView.identifier)
        return layout
    }
    
    private func makeHeaderBoundaryItem(addTopMargin: CGFloat = 0) -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(45.0 + addTopMargin)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func makeShortcutSection() -> NSCollectionLayoutSection {
        let headerSupplimentary = makeHeaderBoundaryItem()
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 2.0),
            heightDimension: .fractionalHeight(1.0)
        ))
        item.contentInsets = .init(top: 0, leading: 8.0, bottom: 0, trailing: 8.0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(120.0)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        section.decorationItems = [backgroundDecorationView]
        section.boundarySupplementaryItems = [headerSupplimentary]
        section.contentInsets = .init(24.0)
        section.ignoreInset(true)
        return section
    }
    
    private func makePillSection() -> NSCollectionLayoutSection {
        let headerSupplimentary = makeHeaderBoundaryItem()
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160.0)
        ))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(160.0)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        section.decorationItems = [backgroundDecorationView]
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [headerSupplimentary]
        section.ignoreInset(true)
        section.contentInsets = .init(top: 12.0, leading: 12.0, bottom: 12.0, trailing: 12.0)
        return section
    }
    
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex
            .define { contentView in
                contentView.addItem(recommendPillCollectionView)
                    .backgroundColor(Constants.Color.background)
                contentView.addItem(footerView)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        scrollView.pin.top().horizontally().bottom()
        contentView.pin.top().horizontally().bottom()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode:.adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
