//
//  DefaultSearchDetailViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import FlexLayout
import PinLayout
import Kingfisher

public final class DefaultSearchDetailViewController: UIViewController, View, SearchDetailViewControllerProtocol {
    
    public var searchDetailView = SearchDetailView()
    
    public var capsuleView: CapsuleView?
    
    public var medicineName: String = ""
    public var footerViewHeight: CGFloat = 300.0
    public var imageHeaderViewHeight: CGFloat = 300.0
    public var disposeBag = DisposeBag()
    private var adapter: SearchDetailAdapter?
    
    public static func create(with reactor: SearchDetailReactor) -> DefaultSearchDetailViewController {
        let viewController = DefaultSearchDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = SearchDetailAdapter(
                tableView: searchDetailView.contentTableView,
                dataSource: reactor,
                delegate: self
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Binding
extension DefaultSearchDetailViewController {
    private func bindAction(_ reactor: SearchDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchDetailView.dismissButton.rx.tap
            .map { Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchDetailReactor) {
        reactor.pulse(\.$pillInfo)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pillInfo in
                guard let pillInfo = pillInfo else { return }
                self?.configure(pillInfo)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$hasPillDescription)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.searchDetailView.contentTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pasteboardString)
            .filter { $0 != nil }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { pasteboardString in
                UIPasteboard.general.string = pasteboardString
                self.showPasteboardCapsule()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: SearchDetailReactor) {
        adapter?.didSelectSection
            .filter { $0 == 0 }
            .map { _ in
                Reactor.Action.didTapImageView
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        adapter?.didSelectRow
            .map { indexPath in
                Reactor.Action.didSelectRow(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - SearchDetail Delegate
extension DefaultSearchDetailViewController: SearchDetailDelegate {
    public func heightForHeader(in section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return imageHeaderViewHeight
    }
    
    public func heightForFooter(in section: Int) -> CGFloat {
        return footerViewHeight
    }
    
    public func scrollViewDidScroll(_ contentOffset: CGPoint) {
        let isHidden = contentOffset.y <= self.imageHeaderViewHeight - (self.view.safeAreaInsets.top + 30)
        UIView.animate(withDuration: 0.2) {
            self.searchDetailView.navigationView.backgroundColor = isHidden ? nil : Constants.Color.background
            self.searchDetailView.navigationTitleLabel.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: - Layout
extension DefaultSearchDetailViewController {
    private func setupLayout() {
        view.addSubview(searchDetailView)
    }
    
    private func setupSubviewLayout() {
        searchDetailView.pin.all()
        searchDetailView.flex.layout()
    }
    
    private func updateSubviewLayout() {
        searchDetailView.updateSubviewLayout()
    }
}
