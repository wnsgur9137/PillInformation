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
    
    private let rootContainerView = UIView()
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.AlarmViewController.alarm
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(24.0)
        return label
    }()
    
    private let alarmTableView = UITableView()
    
    private let footerView = FooterView()
    
    // MARK: - Properties
    
    private var adapter: AlarmAdapter?
    public var disposeBag = DisposeBag()
    
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
        print("indexPath: \(indexPath)")
    }
}

// MARK: - Layout
extension AlarmViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(alarmLabel)
                .marginTop(24.0)
                .marginLeft(36.0)
            
            rootView.addItem(alarmTableView)
                .marginTop(12.0)
            
            rootView.addItem(footerView)
                .marginTop(24.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.left().right().bottom().top(view.safeAreaInsets.top)
        rootContainerView.flex.layout()
    }
}
