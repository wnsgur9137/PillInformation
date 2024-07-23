//
//  ImageDetailViewController.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher
import Photos

public final class ImageDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.systemBlack
        return view
    }()
    
    private let topMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let bottomMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3.0
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.backward, for: .normal)
        button.tintColor = Constants.Color.systemBlue
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteSemiBold(18.0)
        return label
    }()
    
    private let classLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.systemWhite
        label.font = Constants.Font.suiteMedium(12.0)
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.ImageDetail.Image.share, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.ImageDetail.Image.download, for: .normal)
        button.tintColor = Constants.Color.systemWhite
        return button
    }()
    
    private lazy var downloadedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var isHiddenUI: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                let alpha: CGFloat = self.isHiddenUI ? 0 : 1
                self.topMenuView.alpha = alpha
                self.bottomMenuView.alpha = alpha
            }
        }
    }
    
    // MARK: - Life cycle
    public static func create(with reactor: ImageDetailReactor) -> ImageDetailViewController {
        let viewController = ImageDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        scrollView.delegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public func bind(reactor: ImageDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func showActivityViewController() {
        guard let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func showPermissionAlert() {
        AlertViewer()
            .showDualButtonAlert(
                self,
                title: .init(text: "알약 이미지 저장을 위해 설정에서 사진 접근을 허용해주세요."),
                message: nil,
                confirmButtonInfo: .init(title: "설정") {
                    self.moveToSetting()
                },
                cancelButtonInfo: .init(title: Constants.cancel)
            )
    }
    
    private func moveToSetting() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingURL) else {
            return
        }
        UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
    }
    
    private func downloadImage() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(showDownloadedView),
            nil
        )
    }
    
    
    @objc private func showDownloadedView(_: UIImage,
                                          error: Error?,
                                          _: UnsafeRawPointer) {
        view.addSubview(downloadedView)
        downloadedView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        downloadedView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        downloadedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        downloadedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        downloadedView.backgroundColor = Constants.Color.background
        downloadedView.layer.cornerRadius = 24.0
        downloadedView.alpha = 0
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.downloadedView.alpha = 1
            }, completion: { [weak self] _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: 2.0,
                    animations: { [weak self] in
                        self?.downloadedView.alpha = 0
                    },
                    completion: { [weak self] _ in
                        self?.downloadedView.removeFromSuperview()
                    }
                )
            }
        )
    }
}

// MARK: - Binding
extension ImageDetailViewController {
    private func bindAction(_ reactor: ImageDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.rx.gesture(doubleTapGesture)
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.scrollView.zoomScale = 1
                }
            })
            .disposed(by: disposeBag)
        
        let singleTapGesture = UITapGestureRecognizer()
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.require(toFail: doubleTapGesture)
        imageView.rx.gesture(singleTapGesture)
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let isHiddenUI = self?.isHiddenUI else { return }
                self?.isHiddenUI = !isHiddenUI
            })
            .disposed(by: disposeBag)
        
        imageView.rx.swipeGesture(.down)
            .skip(1)
            .when(.recognized)
            .map { _ in Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .subscribe(onNext: {
                self.showActivityViewController()
            })
            .disposed(by: disposeBag)
        
        downloadButton.rx.tap
            .map { Reactor.Action.didTapDownloadButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ImageDetailReactor) {
        reactor.state
            .map { $0.imageURL }
            .filter { $0 != nil }
            .bind(onNext: { [weak self] url in
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.pillName }
            .filter { $0 != nil }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.className }
            .filter { $0 != nil }
            .bind(to: classLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isDeniedPermission }
            .filter { $0 != nil }
            .subscribe(onNext: { _ in
                self.showPermissionAlert()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$download)
            .filter { $0 != nil }
            .subscribe(onNext: { _ in
                self.downloadImage()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollView Delegate
extension ImageDetailViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - Layout
extension ImageDetailViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        rootContainerView.addSubview(topMenuView)
        rootContainerView.addSubview(bottomMenuView)
        
        topMenuView.flex
            .direction(.row)
            .alignItems(.center)
            .define { topMenuView in
                topMenuView.addItem(dismissButton)
                    .width(48.0)
                    .height(48.0)
                topMenuView.addItem()
                    .grow(1)
                    .alignItems(.center)
                    .justifyContent(.center)
                    .define { labelStack in
                        labelStack.addItem(titleLabel)
                        labelStack.addItem(classLabel)
                            .marginTop(5.0)
                    }
                topMenuView.addItem()
                    .width(48.0)
                    .height(48.0)
        }
        
        bottomMenuView.flex
            .direction(.row)
            .alignItems(.center)
            .define { bottomMenuView in
                bottomMenuView.addItem(shareButton)
                    .grow(1.0)
                bottomMenuView.addItem()
                    .border(1.0, Constants.Color.systemWhite)
                    .height(40.0)
                    .width(1.0)
                bottomMenuView.addItem(downloadButton)
                    .grow(1.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        scrollView.pin.all()
        
        imageView.pin
            .width(scrollView.frame.width)
            .height(scrollView.frame.height)
        
        topMenuView.pin
            .left(view.safeAreaInsets.left)
            .top(view.safeAreaInsets.top + 20)
            .right(view.safeAreaInsets.right)
            .height(50.0)
        topMenuView.flex.layout()
        
        bottomMenuView.pin
            .left(view.safeAreaInsets.left)
            .bottom(view.safeAreaInsets.bottom + 20)
            .right(view.safeAreaInsets.right)
            .height(50.0)
        bottomMenuView.flex.layout()
    }
}
