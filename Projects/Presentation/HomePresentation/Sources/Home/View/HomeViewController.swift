//
//  HomeViewController.swift
//  Home
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

public final class HomeViewController: UIViewController, View {
    
    private let rootFlexContainerView = UIView()
    private let searchTextFieldView = SearchTextFieldView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.notice
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(22.0)
        return label
    }()
    
    private let noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.addShadow()
        return tableView
    }()
    
    private let footerView = FooterView()
    
    private var adapter: HomeAdapter?
    public var disposeBag = DisposeBag()
    private lazy var noticeTableRowHeight: CGFloat = 50.0
    
    private let didSelectNoticeSubject: PublishSubject<Int> = .init()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: HomeReactor) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        rootFlexContainerView.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = HomeAdapter(tableView: noticeTableView,
                                  dataSource: reactor,
                                  delegate: self)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextFieldView.searchTextField.resignFirstResponder()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension HomeViewController {
    private func bindAction(_ reactor: HomeReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.loadNotices }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.searchTextField.rx.tapGesture()
            .skip(1)
            .map { _ in Reactor.Action.changeTab(2) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectNoticeSubject
            .map { row in Reactor.Action.didSelectNotice(row)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.state
            .map { $0.noticeCount }
            .bind(onNext: { noticeCount in
                let height = self.noticeTableRowHeight * CGFloat(noticeCount)
                self.noticeTableView.flex.height(height)
                self.noticeTableView.reloadData()
                self.updateSubviewLayout()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFailedLoadNotices }
            .bind(onNext: { isFailedLoadNotices in
                guard isFailedLoadNotices != nil else { return }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - HomeAdapter Delegate
extension HomeViewController: HomeAdapterDelegate {
    public func didSelectRow(at indexPath: IndexPath) {
        didSelectNoticeSubject.onNext(indexPath.row)
    }
    
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return noticeTableRowHeight
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        let contentMargin = UIEdgeInsets(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0)
        view.addSubview(rootFlexContainerView)
        view.addSubview(searchTextFieldView)
        rootFlexContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { contentView in
            contentView.addItem(titleImageView)
                .height(120)
            
            contentView.addItem(noticeLabel)
                .margin(contentMargin)
                .marginTop(24.0)
                .marginLeft(36.0)
            contentView.addItem(noticeTableView)
                .cornerRadius(8.0)
                .margin(contentMargin)
            
            contentView.addItem(footerView)
                .marginTop(24.0)
        }
    }
    
    private func setupSubviewLayout() {
        searchTextFieldView.pin.left().right().top(view.safeAreaInsets.top)
        searchTextFieldView.flex.layout()
        rootFlexContainerView.pin.left().right().bottom().top(to: searchTextFieldView.edge.bottom)
        
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
