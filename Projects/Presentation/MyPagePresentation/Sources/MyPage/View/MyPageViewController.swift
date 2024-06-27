//
//  MyPageViewController.swift
//  MyPage
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

import BasePresentation

public final class MyPageViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.MyPage.Image.xmark, for: .normal)
        button.tintColor = Constants.Color.systemBlack
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MyPage"
        label.textColor = .label
        label.font = Constants.Font.suiteBold(36.0)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Properties
    
    public var didDisappear: (() -> Void)?
    public var disposeBag = DisposeBag()
    private var adapter: MyPageAdapter?
    
    public static func create(with reactor: MyPageReactor) -> MyPageViewController {
        let viewController = MyPageViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = MyPageAdapter(
                tableView: tableView,
                dataSource: reactor,
                delegate: self
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?()
    }
    
    public func bind(reactor: MyPageReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension MyPageViewController {
    private func bindAction(_ reactor: MyPageReactor) {
        dismissButton.rx.tap
            .bind {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MyPageReactor) {
        
    }
    
    private func bindAdapter(_ reactor: MyPageReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - MyPageAdapter TableViewDelegate
extension MyPageViewController: MyPageAdapterDelegate {
    
}

// MARK: - Layout
extension MyPageViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(dismissButton)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(24.0)
            rootView.addItem(tableView)
                .margin(12.0, 12.0, 0, 12.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
        dismissButton.pin.top(24.0).right(12.0).width(48.0).height(48.0)
    }
    
    private func updateSubviewLayout() {
        
    }
}
