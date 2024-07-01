//
//  AlarmViewController.swift
//  Alarm
//
//  Created by JunHyeok Lee on 1/29/24.
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

public final class AlarmViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let alarmTableView = UITableView()
    
    // MARK: - Properties
    
    private var adapter: AlarmAdapter?
    public var disposeBag = DisposeBag()
    
    private var alarmTableViewRowHeight: CGFloat = 140.0
    private var alarmTableViewHeaderHeight: CGFloat = 50.0
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: AlarmReactor) -> AlarmViewController {
        let viewController = AlarmViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let reactor = reactor {
            adapter = AlarmAdapter(tableView: alarmTableView,
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
    
    public func bind(reactor: AlarmReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension AlarmViewController {
    private func bindAction(_ reactor: AlarmReactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AlarmReactor) {
        reactor.pulse(\.$alarmCellCount)
            .subscribe(onNext: { [weak self] _ in
                self?.alarmTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: AlarmReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectToggleButton
            .map { indexPath in
                Reactor.Action.didSelectToggleButton(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectWeekButton
            .map { indexPath, buttonType in
                Reactor.Action.didSelectWeekButton(indexPath: indexPath, buttonType: buttonType)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectAddButton
            .map { Reactor.Action.didSelectAddButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.deleteRow
            .map { indexPath in
                Reactor.Action.delete(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - AlarmAdapter Delegate
extension AlarmViewController: AlarmAdapterDelegate {
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return alarmTableViewRowHeight
    }
    
    func heightForHeader(in section: Int) -> CGFloat {
        return alarmTableViewHeaderHeight
    }
}

// MARK: - Layout
extension AlarmViewController {
    private func setupLayout() {
        view.addSubview(alarmTableView)
    }
    
    private func setupSubviewLayout() {
        alarmTableView.pin.all(view.safeAreaInsets)
    }
}
