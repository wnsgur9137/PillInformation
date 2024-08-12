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

public final class SearchDetailViewController: UIViewController, View {
    
    public var searchDetailView = SearchDetailView()
    
    public var capsuleView: CapsuleView?
    
    public var medicineName: String = ""
    public var footerViewHeight: CGFloat = 300.0
    public var imageHeaderViewHeight: CGFloat = 300.0
    public var disposeBag = DisposeBag()
    private var adapter: SearchDetailAdapter?
    
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
    
    func configure(_ pillInfo: PillInfoModel) {
        medicineName = pillInfo.medicineName
        searchDetailView.navigationTitleLabel.text = medicineName
        searchDetailView.titleLabel.text = medicineName
    }
    
    func showPasteboardCapsule() {
        if capsuleView == nil {
            capsuleView = CapsuleView(Constants.Search.copyComplete)
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
            .flatMap {
                Observable.merge([
                    Observable.just(Reactor.Action.loadBookmark),
                    Observable.just(Reactor.Action.loadPillDescription),
                    Observable.just(Reactor.Action.updateHits)
                ])
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchDetailView.dismissButton.rx.tap
            .map { Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchDetailView.bookmarkButton.rx.tap
            .map { Reactor.Action.didTapBookmarkButton }
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
        
        reactor.pulse(\.$error)
            .filter { $0 != nil }
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isBookmarked }
            .subscribe(onNext: { [weak self] isBookmarked in
                let image = isBookmarked ? Constants.Image.starFill : Constants.Image.star
                self?.searchDetailView.bookmarkButton.setImage(image, for: .normal)
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
extension SearchDetailViewController: SearchDetailDelegate {
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
extension SearchDetailViewController {
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
