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
    
    private var alarmTableViewRowHeight: CGFloat = 100.0
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

// MARK: - Methods
extension AlarmViewController {
    
}

// MARK: - Binding
extension AlarmViewController {
    private func bindAction(_ reactor: AlarmReactor) {
        
    }
    
    private func bindState(_ reactor: AlarmReactor) {
        
    }
}

// MARK: - AlarmAdapter Delegate
extension AlarmViewController: AlarmAdapterDelegate {
    func didSelectRow(at indexPath: IndexPath) {
        reactor?.didSelectRow(at: indexPath)
    }
    
    func didSelectToggleButton(at indexPath: IndexPath) {
        reactor?.didSelectToggleButton(at: indexPath)
    }
    
    func didSelectAddButton() {
        reactor?.didSelectAddButton()
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return alarmTableViewRowHeight
    }
    
    func heightForHeader(in section: Int) -> CGFloat {
        return alarmTableViewHeaderHeight
    }
    
    func deleteRow(at indexPath: IndexPath) {
        reactor?.delete(indexPath: indexPath)
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