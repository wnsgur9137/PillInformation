//
//  TimerViewController.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
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

public final class TimerViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private lazy var emptyTimerView = EmptyTimerView()
    
    private let timerTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    private var adapter: TimerAdapter?
    public var disposeBag = DisposeBag()
    
    var timerTableViewRowHeight: CGFloat = 80.0
    var timerTableViewHeaderHeight: CGFloat = 50.0
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: TimerReactor) -> TimerViewController {
        let viewController = TimerViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let reactor = reactor {
            self.adapter = TimerAdapter(tableView: timerTableView,
                                        dataSource: reactor,
                                        delegate: self)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: TimerReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - React
extension TimerViewController {
    private func bindAction(_ reactor: TimerReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TimerReactor) {
        reactor.state
            .map { $0.timerCellCount }
            .bind(onNext: { [weak self] count in
                self?.timerTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TimerAdapterDelegate
extension TimerViewController: TimerAdapterDelegate {
    public func didSelectAddButton() {
        print("addButton")
    }
    
    public func didSelectRow(at indexPath: IndexPath) {
        reactor?.didSelectRow(at: indexPath)
    }
    
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return timerTableViewRowHeight
    }
    
    public func heightForHeaderIn(section: Int) -> CGFloat {
        return timerTableViewHeaderHeight
    }
    
    public func deleteRow(at indexPath: IndexPath) {
        reactor?.delete(indexPath: indexPath)
    }
}

// MARK: - Layout
extension TimerViewController {
    private func setupLayout() {
        view.addSubview(timerTableView)
    }
    
    private func setupSubviewLayout() {
        timerTableView.pin.all(view.safeAreaInsets)
    }
}
