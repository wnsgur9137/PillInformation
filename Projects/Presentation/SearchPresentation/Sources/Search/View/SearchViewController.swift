//
//  SearchViewController.swift
//  Search
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import FlexLayout
import PinLayout

import BasePresentation

public final class SearchViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchTextFieldView = SearchTextFieldView()
    
    private let recentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = .label
        return label
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchAdapter?
    
    private let searchRelay: PublishRelay<String?> = .init()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: SearchReactor) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        rootContainerView.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = SearchAdapter(collectionView: recentCollectionView,
                                         textField: searchTextFieldView.searchTextField,
                                         collectionViewDataSource: reactor,
                                         collectionViewDelegate: self,
                                         textFieldDelegate: self)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextFieldView.searchTextField.becomeFirstResponder()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension SearchViewController {
    private func bindAction(_ reactor: SearchReactor) {
        searchRelay
            .map { text in
                Reactor.Action.search(text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchReactor) {
        reactor.state
            .map { $0.alertContents }
            .bind(onNext: { contents in
                guard let contents = contents else { return }
                let title = AlertText(text: contents.title)
                let message = AlertText(text: contents.message ?? "")
                let confirmButtonInfo = AlertButtonInfo(title: "확인")
                AlertViewer()
                    .showSingleButtonAlert(self, 
                                           title: title,
                                           message: message,
                                           confirmButtonInfo: confirmButtonInfo)
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - SearchAdapter ColectionViewDelegate
extension SearchViewController: SearchCollectionViewDelegate {
    
}

// MARK: - SearchAdapter TextFieldDelegate
extension SearchViewController: SearchTextFieldDelegate {
    public func shouldReturn(text: String?) {
        searchRelay.accept(text)
    }
}

// MARK: - Layout
extension SearchViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        view.addSubview(searchTextFieldView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { contentView in
            contentView.addItem(recentCollectionView)
                .margin(UIEdgeInsets(top: 12.0, left: 0, bottom: 12.0, right: 0))
                .height(60.0)
            contentView.addItem(label)
                .marginTop(24.0)
                .marginLeft(36.0)
            contentView.addItem(footerView)
                .marginTop(24.0)
        }
    }
    
    private func setupSubviewLayout() {
        searchTextFieldView.pin.left().right().top(view.safeAreaInsets.top)
        searchTextFieldView.flex.layout()
        rootContainerView.pin.left().right().bottom().top(to: searchTextFieldView.edge.bottom)
        scrollView.pin
            .top()
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
        
        contentView.pin.top().horizontally()
        
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
