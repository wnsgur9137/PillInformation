//
//  LocalizationSettingViewController.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 9/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

public final class LocalizationSettingViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: LocalizationSettingAdapter?
    
    // MARK: - Life cycle
    public static func create(with reactor: LocalizationSettingReactor) -> LocalizationSettingViewController {
        let viewController = LocalizationSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        if let reactor = reactor {
            adapter = LocalizationSettingAdapter(
                tableView: tableView,
                dataSource: reactor,
                delegate: self
            )
            bindAdapter(reactor)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: LocalizationSettingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showBottomAlert(title: String) {
        // TODO: - Alert
    }
}

// MARK: - Bind
extension LocalizationSettingViewController {
    private func bindAction(_ reactor: LocalizationSettingReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LocalizationSettingReactor) {
        reactor.state
            .map { $0.currentLocalizationSettingItem }
            .subscribe(onNext: { currentLocalizationSettingItem in
                
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$bottomAlertTitle)
            .subscribe(onNext: { title in
                guard let title = title else { return }
                self.showBottomAlert(title: title)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: LocalizationSettingReactor) {
        adapter?.didSelectRow
            .map { indexPath in Reactor.Action.didSelectRow(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Localize Delegate
extension LocalizationSettingViewController: LocalizationSettingDelegate {
    
}

// MARK: - Layout
extension LocalizationSettingViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
