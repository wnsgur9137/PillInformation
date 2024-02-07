//
//  HomeViewController.swift
//  Home
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import FlexLayout
import PinLayout
import Common
import ReuseableView

public final class HomeViewController: UIViewController, View {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationView = NavigationView()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Color.systemLightGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = Constants.HomeViewController.title
        label.text = "TEST TEXT"
        label.font = Constants.Font.headlineBold1
        return label
    }()
    
    private let searchPicktureButton: UIButton = {
        let button = UIButton()
        let title = "123"
        let titleColor = Constants.Color.systemLabel
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.notice
        label.textColor = Constants.Color.systemLabel
        return label
    }()
    
    private let noticeTableView = UITableView()
    private let footerView = FooterView()
    
    private let viewModel: HomeViewModel
    public var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    public static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController(with: viewModel)
        viewController.reactor = HomeReactor()
        return viewController
    }
    
    public init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.systemBackground
        setupLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    private func setupTableViewDelegate() {
        noticeTableView.dataSource = self
        noticeTableView.delegate = self
    }
}

// MARK: - Binding
extension HomeViewController {
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HomeReactor) {
        searchPicktureButton.rx.tap
            .map { Reactor.Action.didTapTestButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
//            .bind(to: testButton.rx.isEnabled )
            .bind(onNext: { isLoading in
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect (\(indexPath.row))")
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        view.addSubview(scrollView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView)
                .height(1000)
                .define { contentView in
                    contentView.addItem(titleImageView)
                        .height(120)
                    contentView.addItem(titleLabel)
                        .alignSelf(.center)
                    contentView.addItem(searchPicktureButton)
            }
            scrollView.addItem(footerView)
        }
        
    }
    
    private func setupSubviewLayout() {
        scrollView.pin.all()
        scrollView.flex.layout()
        
        contentView.flex.layout()
        footerView.flex.layout()
        let scrollViewContentSize: CGSize = CGSize(width: contentView.frame.width,
                                                   height: contentView.frame.height + footerView.frame.height)
        scrollView.contentSize = scrollViewContentSize
    }
}
