//
//  HomeNoticeViewController.swift
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

public final class HomeNoticeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let footerView = FooterView()
    private lazy var loadingView = LoadingView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Home.notice
        label.font = Constants.Font.suiteSemiBold(24.0)
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.addShadow()
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private let noticeTableRowHeight: CGFloat = 50.0
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeNoticeReactor) -> HomeNoticeViewController {
        let viewController = HomeNoticeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        guard let reactor = reactor else { return }
        loadingView.show(in: self.view)
        noticeTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: HomeNoticeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<NoticeTableViewSectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<NoticeTableViewSectionModel> { _, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return .init() }
            cell.configure(title: item.title)
            return cell
        }
        return dataSource
    }
}

// MARK: - Bind
extension HomeNoticeViewController {
    private func bindAction(_ reactor: HomeNoticeReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.loadNotices }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        noticeTableView.rx.itemSelected
            .map { indexPath in Reactor.Action.didSelectNotice(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeNoticeReactor) {
        reactor.pulse(\.$notices)
            .bind(to: noticeTableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$noticeCount)
            .filter { $0.isNotNull }
            .bind(onNext: { noticeCount in
                guard let noticeCount = noticeCount else { return }
                let height = self.noticeTableRowHeight * CGFloat(noticeCount)
                UIView.animate(withDuration: 0.5,
                               animations: {
                    self.noticeTableView.flex.height(height)
                    self.noticeTableView.reloadData()
                    self.updateSubviewLayout()
                }, completion: { _ in
                    self.loadingView.hide()
                })
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFailedLoadNotices }
            .bind(onNext: {
                self.loadingView.hide()
                // MARK: - TODO: - Load Error Popup
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView Delegate
extension HomeNoticeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return noticeTableRowHeight
    }
}

// MARK: - Layout
extension HomeNoticeViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex
            .define { contentView in
                contentView.addItem(titleLabel)
                    .margin(10.0, 24.0, 10.0, 24.0)
                contentView.addItem(noticeTableView)
                    .marginTop(24.0)
                contentView.addItem(footerView)
                    .marginTop(48.0)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
        
        scrollView.pin.top().horizontally().bottom()
        contentView.pin.top().horizontally()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
