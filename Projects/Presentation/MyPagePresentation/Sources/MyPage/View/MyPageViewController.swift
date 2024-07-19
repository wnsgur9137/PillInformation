//
//  MyPageViewController.swift
//  MyPage
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

import BasePresentation

public final class MyPageViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.xmark, for: .normal)
        button.tintColor = Constants.Color.systemBlack
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.MyPage.myPage
        label.textColor = .label
        label.font = Constants.Font.suiteBold(36.0)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Properties
    
    public var didDisappear: (() -> Void)?
    public var disposeBag = DisposeBag()
    private var adapter: MyPageAdapter?
    
    private let signout = PublishSubject<Void>()
    private let withdraw = PublishSubject<Void>()
    
    public static func create(with reactor: MyPageReactor) -> MyPageViewController {
        let viewController = MyPageViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            self.adapter = MyPageAdapter(
                tableView: tableView,
                dataSource: reactor
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?()
    }
    
    public func bind(reactor: MyPageReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showWarningAlert(_ type: MyPageReactor.MyPageAlert) {
        var title: String = ""
        switch type {
        case .signoutError:
            title = Constants.MyPage.signoutError
        case .withdrawalError:
            title = Constants.MyPage.withdrwalError
        case .warning:
            title = Constants.MyPage.loadError
        default: return
        }
        
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: .init(text: title),
                message: .init(text: Constants.MyPage.tryAgain),
                confirmButtonInfo: .init(title: Constants.confirm) {
                    guard type == .warning else { return }
                    self.dismiss(animated: true)
                }
            )
    }
    
    private func showAlert(_ type: MyPageReactor.MyPageAlert) {
        var title: String = ""
        var message: AlertText?
        var confirm: String = ""
        switch type {
        case .signout: 
            title = Constants.MyPage.askSignout
            confirm = Constants.confirm
        case .withdrawal:
            title = Constants.MyPage.askWithdrawal
            confirm = Constants.MyPage.withdraw
            message = .init(text: Constants.MyPage.withdrawalMessage)
        default : return
        }
        
        AlertViewer()
            .showDualButtonAlert(
                self,
                title: .init(text: title),
                message: message,
                confirmButtonInfo: .init(title: confirm) {
                    switch type {
                    case .signout: self.signout.onNext(Void())
                    case .withdrawal: self.withdraw.onNext(Void())
                    default: break
                    }
                },
                cancelButtonInfo: .init(title: Constants.cancel)
            )
    }
}

// MARK: - Binding
extension MyPageViewController {
    private func bindAction(_ reactor: MyPageReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .bind {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        signout
            .map { Reactor.Action.signOut }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        withdraw
            .map { Reactor.Action.withdrawal }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MyPageReactor) {
        reactor.pulse(\.$alert)
            .filter { $0 != nil }
            .asDriver(onErrorDriveWith: .never())
            .drive { type in
                guard let type = type else { return }
                if type == .signout || type == .withdrawal {
                    self.showAlert(type)
                }
                self.showWarningAlert(type)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$dismiss)
            .filter { $0 != nil}
            .asDriver(onErrorDriveWith: .never())
            .drive { animated in
                self.dismiss(animated: animated ?? true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: MyPageReactor) {
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension MyPageViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(dismissButton)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(titleLabel)
                .margin(24.0)
            rootView.addItem(tableView)
                .margin(12.0, 12.0, 0, 12.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
        dismissButton.pin.top(24.0).right(12.0).width(48.0).height(48.0)
    }
    
    private func updateSubviewLayout() {
        
    }
}
