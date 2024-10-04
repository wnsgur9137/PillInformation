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

import BasePresentation

public final class SearchShapeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let selectedShapeView = UIView()
    
    private let selectedShapeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Search.selectedShape
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteMedium(22.0)
        return label
    }()
    
    private let selectedShapeScrollView = UIScrollView()
    private let selectedShapeContentView = UIView()
    
    private let selectedShapeContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Constants.Color.background
        return collectionView
    }()
    
    private let navigationSearchButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: Constants.Search.search, style: .plain, target: nil, action: nil)
        return barButton
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
        title = Constants.Search.title
        view.backgroundColor = Constants.Color.background
        navigationItem.rightBarButtonItem = navigationSearchButton
        if let reactor = reactor {
            adapter = SearchShapeAdapter(
                collectionView: collectionView,
                dataSource: reactor
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchShapeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showAlert(title: String, message: String?) {
        var messageText: AlertText?
        if let message = message {
            messageText = AlertText(text: message)
        }
        AlertViewer()
            .showSingleButtonAlert(
                in: view,
                title: .init(text: title),
                message: messageText,
                confirmButtonInfo: .init(title: Constants.confirm)
            )
    }
}

// MARK: - Binding
extension SearchShapeViewController {
    private func bindAction(_ reactor: SearchShapeReactor) {
        navigationSearchButton.rx.tap
            .map { Reactor.Action.search }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchShapeReactor) {
        reactor.pulse(\.$errorAlertContents)
            .filter { $0.isNotNull }
            .subscribe(onNext: { contents in
                guard let contents = contents else { return }
                self.showAlert(title: contents.title, message: contents.message)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedOptions }
            .filter { $0.isNotNull }
            .distinctUntilChanged()
            .map { selectedOptions -> String? in
                return selectedOptions?.joined(separator: ", ")
            }
            .subscribe(onNext: { [weak self] selectedOptions in
                guard let self = self else { return }
                self.selectedShapeContentLabel.text = selectedOptions
                self.selectedShapeContentLabel.flex.markDirty()
                self.selectedShapeContentView.flex.layout(mode: .adjustWidth)
                self.selectedShapeScrollView.contentSize = self.selectedShapeContentView.frame.size
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: SearchShapeReactor) {
        adapter?.didSelectItem
            .map { values in return Reactor.Action.didSelectShapeButton(values) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectSearchButton
            .map { Reactor.Action.search }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension SearchShapeViewController {
    private func setupLayout() {
        view.addSubview(selectedShapeView)
        selectedShapeView.addSubview(selectedShapeLabel)
        selectedShapeView.addSubview(selectedShapeScrollView)
        selectedShapeScrollView.addSubview(selectedShapeContentView)
        view.addSubview(collectionView)
        
        selectedShapeView.flex.backgroundColor(Constants.Color.background)
        
        selectedShapeContentView.flex
            .define { contentView in
                contentView.addItem(selectedShapeContentLabel)
                    .height(100%)
                    .minWidth(100)
            }
    }
    
    private func setupSubviewLayout() {
        selectedShapeView.pin.top(view.safeAreaInsets.top).left().right().height(10%).minHeight(100.0)
        selectedShapeLabel.pin.top(12.0).left(12.0).right(12.0).height(20%)
        selectedShapeScrollView.pin.top(to: selectedShapeLabel.edge.bottom).left(12.0).right(12.0).bottom(12.0).height(80%)
        selectedShapeContentView.pin.left().vertically()
        selectedShapeContentView.flex.layout()
        selectedShapeScrollView.contentSize = selectedShapeContentView.frame.size
        
        collectionView.pin.top(to: selectedShapeView.edge.bottom).left(view.safeAreaInsets.left).right(view.safeAreaInsets.right).bottom(view.safeAreaInsets.bottom)
    }
}
