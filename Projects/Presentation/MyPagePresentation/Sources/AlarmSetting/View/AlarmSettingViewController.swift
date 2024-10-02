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
import RxDataSources
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
        tableView.register(AlarmSettingTableViewCell.self, forCellReuseIdentifier: AlarmSettingTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private let popViewController: PublishRelay<Void> = .init()
    private let didSelectAlarmSwitch: PublishRelay<IndexPath> = .init()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: AlarmSettingReactor) -> AlarmSettingViewController {
        let viewController = AlarmSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
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
    
    private func createTableViewDataSource() -> RxTableViewSectionedReloadDataSource<AlarmSettingTableViewSectionItem> {
        let dataSource = RxTableViewSectionedReloadDataSource<AlarmSettingTableViewSectionItem> { [weak self] _, tableView, indexPath, item in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: AlarmSettingTableViewCell.identifier, for: indexPath) as? AlarmSettingTableViewCell else { return .init() }
            cell.configure(item)
            cell.toggleButton.rx.isOn
                .skip(1)
                .map { _ in return indexPath }
                .bind(to: self.didSelectAlarmSwitch)
                .disposed(by: cell.disposeBag)
            return cell
        }
        return dataSource
    }
    
    private func showErrorAlert(_ contents: (title: String, message: String?), needDismiss: Bool) {
        AlertViewer()
            .showSingleButtonAlert(
                in: view,
                title: AlertText(text: contents.title),
                message: AlertText(text: contents.message ?? ""),
                confirmButtonInfo: AlertButtonInfo(
                    title: Constants.confirm,
                    action: { [weak self] in
                        guard needDismiss else { return }
                        self?.popViewController.accept(Void())
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
        
        didSelectAlarmSwitch
            .map { indexPath in Reactor.Action.didSelectRow(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AlarmSettingReactor) {
        reactor.pulse(\.$tableViewItems)
            .filter { !$0.isEmpty }
            .bind(to: tableView.rx.items(dataSource: createTableViewDataSource()))
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
}

// MARK: - UITableView Delegate
extension AlarmSettingViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
