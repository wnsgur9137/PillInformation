//
//  SearchShapeViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class SearchShapeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Constants.Color.background
        return collectionView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let color = Constants.Color.systemWhite
        button.setImage(Constants.Image.magnifyingglass, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.tintColor = color
        return button
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: SearchShapeAdapter?
    
    public static func create(with reactor: SearchShapeReactor) -> SearchShapeViewController {
        let viewController = SearchShapeViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        if let reactor = reactor {
            adapter = SearchShapeAdapter(
                collectionView: collectionView,
                dataSource: reactor
            )
            bindAdapter(reactor)
        }
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: SearchShapeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showAlert(title: String, message: String?) {
        var messageText: AlertText?
        if let message = message {
            messageText = AlertText(text: message)
        }
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: .init(text: title),
                message: messageText,
                confirmButtonInfo: .init(title: Constants.confirm)
            )
    }
}

// MARK: - Binding
extension SearchShapeViewController {
    private func bindAction(_ reactor: SearchShapeReactor) {
        searchButton.rx.tap
            .map { Reactor.Action.search }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SearchShapeReactor) {
        reactor.pulse(\.$errorAlertContents)
            .filter { $0 != nil }
            .subscribe(onNext: { contents in
                guard let contents = contents else { return }
                self.showAlert(title: contents.title, message: contents.message)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAdapter(_ reactor: SearchShapeReactor) {
        adapter?.didSelectItem
            .map { values in return Reactor.Action.didSelectShapeButton(values) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension SearchShapeViewController {
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(searchButton)
        
        searchButton.flex
            .border(0.5, Constants.Color.systemWhite)
            .cornerRadius(18.0)
            .backgroundColor(Constants.Color.googleBlue)
            .height(48.0)
    }
    
    private func setupSubviewLayout() {
        collectionView.pin.all(view.safeAreaInsets)
        searchButton.pin
            .minWidth(48.0)
            .height(48.0)
            .hCenter()
            .bottom(25.0)
    }
}
