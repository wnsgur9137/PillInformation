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
        label.text = Constants.MyPage.title
        label.textColor = Constants.Color.label
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
    private let popViewController = PublishSubject<Void>()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: AlarmSettingReactor) -> AlarmSettingViewController {
        let viewController = AlarmSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = AlarmSettingAdapter(
                tableView: tableView,
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func bind(reactor: AlarmSettingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showErrorAlert(_ contents: (title: String, message: String?), needDismiss: Bool) {
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: AlertText(text: contents.title),
                message: AlertText(text: contents.message ?? ""),
                confirmButtonInfo: AlertButtonInfo(title: Constants.confirm, action: { [weak self] in
                    guard needDismiss else { return }
                    self?.popViewController.onNext(Void())
                })
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
        
        popViewController
            .map { Reactor.Action.popViewController }
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
                self?.showErrorAlert(errorContents.contents, needDismiss: errorContents.needDismiss)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: AlarmSettingReactor) {
        adapter?.didSelectSwitch
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
                .margin(12.0)
                .grow(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
}
