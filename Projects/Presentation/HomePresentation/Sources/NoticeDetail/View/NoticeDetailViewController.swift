//
//  NoticeDetailViewController.swift
//  Home
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class NoticeDetailViewController: UIViewController, View {
    
    private let rootContainerView = UIView()
    private let searchTextFieldView = SearchTextFieldView(hasDismiss: true)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
//    private lazy var navigationView = NavigationView(useTextField: false, isShowBackwardButton: true)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteBold(32.0)
        label.textColor = Constants.Color.systemLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteRegular(18.0)
        label.textColor = Constants.Color.systemLightGray
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteRegular(18.0)
        label.textColor = Constants.Color.systemLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let otherNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.NoticeDetailViewController.otherNotice
        label.font = Constants.Font.suiteMedium(18.0)
        label.textColor = Constants.Color.systemLabel
        return label
    }()
    
    private let otherNoticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let footerView = FooterView()
    
    public var disposeBag = DisposeBag()
    private var adapter: NoticeDetailAdapter?
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: NoticeDetailReactor) -> NoticeDetailViewController {
        let viewController = NoticeDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = NoticeDetailAdapter(tableView: otherNoticeTableView,
                                               dataSource: reactor)
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: NoticeDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension NoticeDetailViewController {
    private func bindAction(_ reactor: NoticeDetailReactor) {
        rx.viewDidLoad
            .flatMap { _ in
                Observable.concat(
                    Observable.just(Reactor.Action.loadNotice),
                    Observable.just(Reactor.Action.loadOtherNotices)
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.dismissButton.rx.tap
            .map { Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTextFieldView.userIconButton.rx.tap
            .map { Reactor.Action.didTapUserButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: NoticeDetailReactor) {
        reactor.state
            .map { $0.notice }
            .filter { $0 != nil }
            .bind(onNext: { [weak self] notice in
                guard let notice = notice else { return }
                self?.titleLabel.text = notice.title
                self?.writerLabel.text = notice.writer
                self?.contentLabel.text = notice.content
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoadedOtherNotices }
            .bind(onNext: { _ in
                self.otherNoticeTableView.reloadData()
                self.updateSubviewLayout()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: NoticeDetailReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectNotice(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension NoticeDetailViewController {
    private func setupLayout() {
        let defaultMargin = UIEdgeInsets(top: 24.0, left: 12.0, bottom: 0, right: 12.0)
        view.addSubview(rootContainerView)
        view.addSubview(searchTextFieldView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { contentView in
            contentView.addItem(titleLabel)
                .margin(defaultMargin)
            contentView.addItem(writerLabel)
                .margin(defaultMargin)
                .marginTop(12.0)
            
            contentView.addItem()
                .height(1.0)
                .backgroundColor(Constants.Color.systemLabel)
                .margin(defaultMargin)
            
            contentView.addItem(contentLabel)
                .margin(defaultMargin)
            
            contentView.addItem()
                .height(1.0)
                .backgroundColor(Constants.Color.systemLabel)
                .margin(defaultMargin)
            
            contentView.addItem(otherNoticeLabel)
                .margin(defaultMargin)
                .marginLeft(24.0)
            contentView.addItem(otherNoticeTableView)
                .margin(defaultMargin)
                .grow(1.0)
            
            contentView.addItem()
                .height(1.0)
                .backgroundColor(Constants.Color.systemLabel)
                .margin(defaultMargin)
            
            contentView.addItem(footerView)
                .marginTop(48.0)
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
