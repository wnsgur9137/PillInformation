//
//  HomeViewController.swift
//  Home
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

import Common
import ReuseableView

public final class HomeViewController: UIViewController, View {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var navigationView = NavigationView(useTextField: true)
    
    private let keyboardBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    
    private let searchPillByShapeButtonView: SearchPillButtonView = {
        let image = Constants.HomeViewController.Image.pills
        let title = Constants.HomeViewController.searchPillByShape
        let view = SearchPillButtonView(image: image, title: title)
        return view
    }()
    
    private let searchPillByPhotoButtonView: SearchPillButtonView = {
        let image = Constants.HomeViewController.Image.camera
        let title = Constants.HomeViewController.searchPillByPhoto
        let view = SearchPillButtonView(image: image, title: title)
        return view
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.notice
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(22.0)
        return label
    }()
    
    private let noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let footerView = FooterView()
    
    private var adapter: HomeAdapter?
    public var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    public static func create(with reactor: HomeReactor) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        if let reactor = reactor {
            adapter = HomeAdapter(tableView: noticeTableView,
                                  dataSource: reactor,
                                  delegate: self)
        }
        setupSearchButtons()
        setupKeyboard()
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
}

// MARK: - Functions
extension HomeViewController {
    private func setupSearchButtons() {
        searchPillByShapeButtonView.button.rx.tap
            .asDriver()
            .drive(onNext: {
                print("Search Pill by Shape")
            })
            .disposed(by: disposeBag)
        
        searchPillByPhotoButtonView.button.rx.tap
            .asDriver()
            .drive(onNext: {
                print("Search Pill by Photo")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        keyboardBackgroundView.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        rx.showKeyboard
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] _ in
                self?.keyboardBackgroundView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        rx.hideKeyboard
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] _ in
                self?.keyboardBackgroundView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding
extension HomeViewController {
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HomeReactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.loadNotices }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.state
            .map { $0.isLoadedNotices }
            .bind(onNext: { isLoadedNotices in
                self.noticeTableView.reloadData()
                self.updateSubviewLayout()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - HomeAdapter Delegate
extension HomeViewController: HomeAdapterDelegate {
    public func didSelectRow(at indexPath: IndexPath) {
        reactor?.didSelectNoticeRow(at: indexPath.row)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        let contentMargin = UIEdgeInsets(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0)
        view.addSubview(scrollView)
        view.addSubview(keyboardBackgroundView)
        view.addSubview(navigationView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView)
                .marginTop(navigationView.height)
                .define { contentView in
                    contentView.addItem(titleImageView)
                        .height(120)
                    
                    contentView.addItem()
                        .direction(.row)
                        .justifyContent(.center)
                        .marginTop(24.0)
                        .define { buttonStack in
                            buttonStack.addItem(searchPillByShapeButtonView)
                                .margin(8.0)
                            buttonStack.addItem(searchPillByPhotoButtonView)
                                .margin(8.0)
                        }
                    
                    contentView.addItem(noticeLabel)
                        .margin(contentMargin)
                        .marginTop(24.0)
                        .marginLeft(36.0)
                    contentView.addItem(noticeTableView)
                        .margin(contentMargin)
                        .marginBottom(24.0)
                        .grow(1)
                    contentView.addItem(footerView)
            }
        }
    }
    
    private func setupSubviewLayout() {
        keyboardBackgroundView.pin.all()
        navigationView.pin.top().left().right()
        navigationView.flex.layout()
        scrollView.pin.all()
        scrollView.flex.layout()
        contentView.flex.layout()
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height + navigationView.height)
    }
    
    private func updateSubviewLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.flex.layout()
        scrollView.contentSize = CGSize(width: contentView.frame.width,
                                        height: contentView.frame.height + navigationView.height)
    }
}
