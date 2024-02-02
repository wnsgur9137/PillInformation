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

public final class HomeViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let searchPicktureButton: UIButton = {
        let button = UIButton()
        let title = Constants.HomeViewController.title
        let titleColor = Constants.Color.systemLabel
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Color.systemLightGray
        return imageView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let noticeTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let viewModel: HomeViewModel
    private let reactor: HomeReactor
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    public static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController(with: viewModel)
        return viewController
    }
    
    public init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.reactor = DefaultHomeReactor()
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
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayout() {
        view.addSubview(scrollView)
        
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView).define { contentView in
                contentView.addItem(titleImageView)
                    .height(120)
                contentView.addItem(searchPicktureButton)
            }
        }
    }
    
    private func setupSubviewLayout() {
        scrollView.pin.all()
        scrollView.flex.layout()
        
        contentView.flex.layout()
        scrollView.contentSize = contentView.frame.size
    }
}
