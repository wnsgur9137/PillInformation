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
    
    private let rootContainerView = UIView()
    private let alarmTableView = UITableView()
    private let navigationView = NavigationView(useTextField: false)
    private let footerView = FooterView()
    
    private var adapter: AlarmAdapter?
    public var disposeBag = DisposeBag()
    
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
        print("indexPath: \(indexPath)")
    }
}

// MARK: - Layout
extension AlarmViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        view.addSubview(navigationView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(alarmTableView)
                .marginTop(navigationView.height)
            rootView.addItem(footerView)
        }
    }
    
    private func setupSubviewLayout() {
        navigationView.pin.left().right().top(view.safeAreaInsets.top)
        navigationView.flex.layout()
        
        rootContainerView.pin.left().right().bottom().top(view.safeAreaInsets.top)
        rootContainerView.flex.layout()
    }
}
