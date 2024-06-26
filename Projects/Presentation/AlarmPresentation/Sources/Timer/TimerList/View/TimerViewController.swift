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
    
    private let timerTableView = UITableView()
    
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
            bindAdapter(reactor)
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
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TimerReactor) {
        reactor.pulse(\.$timerCellCount)
            .bind(onNext: { [weak self] count in
                self?.timerTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: TimerReactor) {
        adapter?.didSelectAddButton
            .map { Reactor.Action.didSelectAddButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.deleteRow
            .map { indexPath in
                Reactor.Action.deleteRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - TimerAdapterDelegate
extension TimerViewController: TimerAdapterDelegate {
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return timerTableViewRowHeight
    }
    
    public func heightForHeader(in section: Int) -> CGFloat {
        return timerTableViewHeaderHeight
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
