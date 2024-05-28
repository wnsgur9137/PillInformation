//
//  SearchDetailViewController.swift
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

import BasePresentation

public final class SearchDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let navigationView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var capsuleView: CapsuleView?
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        button.setTitleColor(Constants.Color.systemBlue, for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteBold(18.0)
        label.numberOfLines = 2
        label.alpha = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let contentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInset = .zero
        return tableView
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var medicineName: String = ""
    private var adapter: SearchDetailAdapter?
    private let imageHeaderViewHeight: CGFloat = 300.0
    private let footerViewHeight: CGFloat = 300.0
    
    private let didTapImageHeaderViewSubject: PublishSubject<Void> = .init()
    private let didSelectRowSubject: PublishSubject<IndexPath> = .init()
    
    // MARK: - LifeCycle
    public static func create(with reactor: SearchDetailReactor) -> SearchDetailViewController {
        let viewController = SearchDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = SearchDetailAdapter(
                tableView: contentTableView,
                dataSource: reactor,
                delegate: self
            )
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
    
    private func configure(_ pillInfo: PillInfoModel) {
        medicineName = pillInfo.medicineName
        navigationTitleLabel.text = medicineName
        titleLabel.text = medicineName
    }
    
    private func showPasteboardCapsule() {
        if capsuleView == nil {
            capsuleView = CapsuleView(Constants.SearchDetail.copyComplete)
            capsuleView?.translatesAutoresizingMaskIntoConstraints = false
            guard let capsuleView = capsuleView else { return }
            view.addSubview(capsuleView)
            capsuleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            capsuleView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            capsuleView.widthAnchor.constraint(greaterThanOrEqualToConstant: capsuleView.minWidth).isActive = true
            capsuleView.heightAnchor.constraint(equalToConstant: capsuleView.height).isActive = true
        }
        guard let capsuleView = capsuleView else { return }
        let y = capsuleView.height + 20
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            capsuleView.transform = .init(translationX: 0, y: -y)
        } completion: { _ in
            // TODO: - 17.0 이상으로 올린 후 capsuleView.imageView.image에 bounce 주기
            UIView.animate(withDuration: 1,
                           delay: 0.5,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut) {
                capsuleView.transform = .init(translationX: 0, y: y)
            }
        }
    }
}

// MARK: - Binding
extension SearchDetailViewController {
    private func bindAction(_ reactor: SearchDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .map { Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didTapImageHeaderViewSubject
            .map { _ in Reactor.Action.didTapImageView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        didSelectRowSubject
            .map { indexPath in Reactor.Action.didSelectRow(indexPath) }
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
                self.contentTableView.reloadData()
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
}

// MARK: - SearchDetail Delegate
extension SearchDetailViewController: SearchDetailDelegate {
    public func didSelectSection(at section: Int) {
        guard section == 0 else { return }
        didTapImageHeaderViewSubject.onNext(Void())
    }
    
    public func didSelectRow(at indexPath: IndexPath) {
        didSelectRowSubject.onNext(indexPath)
    }
    
    public func heightForHeader(in section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return imageHeaderViewHeight
    }
    
    public func heightForFooter(in section: Int) -> CGFloat {
        return footerViewHeight
    }
    
    public func scrollViewDidScroll(_ contentOffset: CGPoint) {
        let isHidden = contentOffset.y <= self.imageHeaderViewHeight - self.view.safeAreaInsets.top
        UIView.animate(withDuration: 0.5) {
            self.navigationView.backgroundColor = isHidden ? nil : Constants.Color.background
            self.navigationTitleLabel.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: - Layout
extension SearchDetailViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        rootContainerView.addSubview(navigationView)
        rootContainerView.addSubview(navigationTitleLabel)
        rootContainerView.addSubview(dismissButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentTableView)
        
        contentView.flex.define { contentView in
            contentView.addItem(contentTableView)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        navigationTitleLabel.pin.top(view.safeAreaInsets.top).left().right().height(48.0)
        dismissButton.pin
            .centerLeft(to: navigationTitleLabel.anchor.centerLeft).marginLeft(12.0)
            .width(48.0)
            .height(48.0)
        navigationView.pin.top().left().right().bottom(to: navigationTitleLabel.edge.bottom)
        scrollView.pin.top().horizontally().bottom()
        scrollView.flex.layout()
        contentView.pin.top(to: rootContainerView.edge.top).horizontally()
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateSubviewLayout() {
        contentTableView.flex.layout()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
    }
}
