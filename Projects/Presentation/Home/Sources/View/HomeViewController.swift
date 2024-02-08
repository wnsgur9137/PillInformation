//
//  HomeViewController.swift
//  Home
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import FlexLayout
import PinLayout
import Common
import ReuseableView

public final class HomeViewController: UIViewController, View {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationView = NavigationView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Color.systemLightGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.title
        label.font = Constants.Font.suiteBold(35.0)
        return label
    }()
    
//    private let searchPicktureButton: UIButton = {
//        let button = UIButton()
//        let title = Constants.HomeViewController.searchPillByPhoto
//        let titleColor = Constants.Color.systemLabel
//        button.setTitle(title, for: .normal)
//        button.setTitleColor(titleColor, for: .normal)
//        button.titleLabel?.font = Constants.Font.button1
//        return button
//    }()
    
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
        return tableView
    }()
    
    private let footerView = FooterView()
    
    public var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: HomeReactor) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        setupTableView()
        
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    private func setupTableView() {
        noticeTableView.dataSource = self
        noticeTableView.delegate = self
        noticeTableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
    }
}

// MARK: - Binding
extension HomeViewController {
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HomeReactor) {
//        searchPicktureButton.rx.tap
//            .map { Reactor.Action.didTapTestButton }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
//        reactor.state
//            .map { $0.isLoading }
//            .distinctUntilChanged()
////            .bind(to: testButton.rx.isEnabled )
//            .bind(onNext: { isLoading in
//            })
//            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return .init() }
        cell.configure(title: "TEST")
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        let contentMargin = UIEdgeInsets(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0)
        view.addSubview(scrollView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView)
                .define { contentView in
                    contentView.addItem(titleImageView)
                        .height(120)
                    contentView.addItem(titleLabel)
                        .marginTop(24.0)
                        .alignSelf(.center)
                    
                    contentView.addItem(noticeLabel)
                        .margin(contentMargin)
                        .marginTop(48.0)
                    contentView.addItem(noticeTableView)
                        .margin(contentMargin)
                        .marginBottom(24.0)
            }
            scrollView.addItem(footerView)
        }
        
    }
    
    private func setupSubviewLayout() {
        scrollView.pin.all()
        scrollView.flex.layout()
        
        contentView.flex.layout()
        let scrollViewContentSize: CGSize = CGSize(width: contentView.frame.width,
                                                   height: contentView.frame.height + footerView.frame.height)
        scrollView.contentSize = scrollViewContentSize
    }
}
