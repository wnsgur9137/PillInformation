//
//  AlarmSettingViewController.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

import BasePresentation

public final class AlarmSettingViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(32.0)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: AlarmSettingAdapter?
    
    // MARK: - Life cycle
    
    public static func create(with reactor: AlarmSettingReactor) -> AlarmSettingViewController {
        let viewController = AlarmSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let reactor = reactor {
            adapter = AlarmSettingAdapter(
                tableView: tableView,
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
    
    public func bind(reactor: AlarmSettingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showSingleAlert(_ contents: (title: String, message: String?)) {
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: AlertText(text: contents.title),
                message: AlertText(text: contents.message ?? ""),
                confirmButtonInfo: .init(title: Constants.confirm)
            )
    }
}

// MARK: - Binding
extension AlarmSettingViewController {
    private func bindAction(_ reactor: AlarmSettingReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AlarmSettingReactor) {
        reactor.state
            .map { $0.reloadData }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$errorAlertContents)
            .filter { $0 != nil }
            .asDriver(onErrorDriveWith: .never())
            .drive { [weak self] errorContents in
                guard let errorContents = errorContents else { return }
                self?.showSingleAlert(errorContents)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: AlarmSettingReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension AlarmSettingViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(24.0, 12.0, 24.0, 12.0)
            rootView.addItem(tableView)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
